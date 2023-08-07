class GroupsController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  before_action :authorized_user
  before_action :set_group, only: [:show, :edit, :update, :destroy, :edit_role, :update_role]

  include CommonModule

  # GET /groups
  # GET /groups.json
  def index
    @page = params[:page]
    if is_blank(@page)
      @page = 1
    end
    @search_query = params[:search]
    if is_blank(@search_query)
      @groups = Group.paginate(page: @page, :per_page => PAGING_CONFIG[:LIMIT])
    else
      @groups = Group.where("name LIKE ?", "%#{@search_query}%").paginate(page: @page, :per_page => PAGING_CONFIG[:LIMIT])
    end
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(group_params)

    respond_to do |format|
      if @group.save
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url, notice: 'Group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /groups/1/edit_role
  def edit_role
    role_ids = []
    @group.roles.each do |item|
      role_ids.push(item.id)
    end
    @group.role_ids = role_ids
    @roles = Role.all
  end

  # PATCH/PUT /groups/1/edit_role
  # PATCH/PUT /groups/1.json/edit_role
  def update_role
    # Get current roles of group
    current_role_ids = []
    @group.roles.each do |item|
      current_role_ids.push(item.id)
    end
    # Get edit roles
    role_ids = params[:group][:role_ids].reject(&:empty?).map(&:to_i)

    delete_role_ids = current_role_ids - role_ids
    if !is_blank(delete_role_ids)
      delete_role_ids.each do |item|
        GroupRole.where('group_id = ? AND role_id = ?', @group.id, item).destroy_all
      end
    end

    new_role_ids = role_ids - current_role_ids
    if !is_blank(new_role_ids)
      new_role_ids.each do |item|
        group_role = GroupRole.new
        group_role.group_id = @group.id
        group_role.role_id = item
        group_role.save
      end
    end

    respond_to do |format|
      format.html { redirect_to @group, notice: 'Role Group was successfully updated.' }
      format.json { render :show, status: :ok, location: @group }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_group
    @group = Group.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def group_params
    params.require(:group).permit(:name, :description)
  end
end
