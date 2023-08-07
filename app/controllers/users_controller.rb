class UsersController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  before_action :authorized_user
  before_action :set_user, only: [:show, :edit, :update, :destroy,
                                  :activate, :change_password, :execute_change_password, :reset_password, :lock, :unlock]

  include CommonModule

  # GET /users
  # GET /users.json
  def index
    @page = params[:page]
    if is_blank(@page)
      @page = 1
    end
    @search_query = params[:search]
    if is_blank(@search_query)
      @users = User.includes(:groups).paginate(page: @page, :per_page => PAGING_CONFIG[:LIMIT])
    else
      @users = User.includes(:groups).where("email LIKE ? OR name LIKE ?", "%#{@search_query}%", "%#{@search_query}%").paginate(page: @page, :per_page => PAGING_CONFIG[:LIMIT])
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
    @user.birthday = DateTime.now
    @user.group_ids = []
    @groups = Group.all
  end

  # GET /users/1/edit
  def edit
    group_ids = []
    @user.groups.each do |item|
      group_ids.push(item.id)
    end
    @user.group_ids = group_ids
    @groups = Group.all
  end

  # POST /users
  # POST /users.json
  def create
    result = true
    @user = User.new(user_params)
    @user.password = PASSWORD_DEFAULT

    respond_to do |format|
      if @user.save

        # Save user_group
        group_ids = params[:user][:group_ids].reject(&:empty?).map(&:to_i)
        if !is_blank(group_ids)
          group_ids.each do |item|
            user_group = UserGroup.new
            user_group.user_id = @user.id
            user_group.group_id = item
            ActiveRecord::Base::transaction do
              _ok = user_group.save
              raise ActiveRecord::Rollback, result = false unless _ok
            end
            if result == false
              format.html { render :new }
              format.json { render json: @user.errors, status: :unprocessable_entity }
            end
          end
        end

        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(update_params)

        # Save user_group
        # Get current group
        current_group_ids = []
        @user.groups.each do |item|
          current_group_ids.push(item.id)
        end
        # Get edit group
        group_ids = params[:user][:group_ids].reject(&:empty?).map(&:to_i)

        delete_group_ids = current_group_ids - group_ids
        if !is_blank(delete_group_ids)
          delete_group_ids.each do |item|
            UserGroup.where('user_id = ? AND group_id = ?', @user.id, item).destroy_all
          end
        end

        new_group_ids = group_ids - current_group_ids
        if !is_blank(new_group_ids)
          new_group_ids.each do |item|
            user_group = UserGroup.new
            user_group.user_id = @user.id
            user_group.group_id = item
            user_group.save
          end
        end

        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /users/1/activated
  def activate
    @user.confirm
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully activated.' }
      format.json { head :no_content }
    end
  end

  # GET /users/1/change_password
  def change_password
  end

  # POST /users/1/change_password
  def execute_change_password
    respond_to do |format|
      if @user.reset_password(change_password_params["password"], change_password_params["password_confirmation"])
        format.html { redirect_to users_url, notice: 'User was successfully updated password.' }
        format.json { head :no_content }
      else
        format.html { render :change_password }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /users/1/reset-password
  def reset_password
    @user.send_reset_password_instructions
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully reset password via email.' }
      format.json { head :no_content }
    end
  end

  # GET /users/1/locked
  def lock
    @user.lock_access!({send_instructions: false})
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully locked.' }
      format.json { head :no_content }
    end
  end

  # GET /users/1/unlocked
  def unlock
    @user.unlock_access!
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully unlocked.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    # params.fetch(:user, {}).permit(:email)
    params.require(:user).permit(:email, :name, :birthday)
  end

  def update_params
    params.require(:user).permit(:name, :birthday)
  end

  def change_password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
