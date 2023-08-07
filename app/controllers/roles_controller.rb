class RolesController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  before_action :authorized_user
  before_action :set_role, only: [:show, :edit, :update, :destroy]

  include CommonModule

  # GET /roles
  # GET /roles.json
  def index
    @page = params[:page]
    if is_blank(@page)
      @page = 1
    end
    @search_query = params[:search]
    if is_blank(@search_query)
      @roles = Role.paginate(page: @page, :per_page => PAGING_CONFIG[:LIMIT])
    else
      @roles = Role.where("name LIKE ?", "%#{@search_query}%").paginate(page: @page, :per_page => PAGING_CONFIG[:LIMIT])
    end
  end

  # GET /roles/1
  # GET /roles/1.json
  def show
  end

  # GET /roles/new
  def new
    @role = Role.new
    @actions = ENV['ROLE_ACTION_ENUM'].split(',').map(&:strip)
    @resources = ENV['ROLE_RESOURCE_ENUM'].split(',').map(&:strip)
  end

  # GET /roles/1/edit
  def edit
    @actions = ENV['ROLE_ACTION_ENUM'].split(',').map(&:strip)
    @resources = ENV['ROLE_RESOURCE_ENUM'].split(',').map(&:strip)
  end

  # POST /roles
  # POST /roles.json
  def create
    @role = Role.new(role_params)
    @role.name = role_params[:action] + "_" + role_params[:resource]
    respond_to do |format|
      if @role.save
        format.html { redirect_to @role, notice: 'Role was successfully created.' }
        format.json { render :show, status: :created, location: @role }
      else
        format.html { render :new }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /roles/1
  # PATCH/PUT /roles/1.json
  def update
    @role.name = role_params[:action] + "_" + role_params[:resource]
    respond_to do |format|
      if @role.update(role_params)
        format.html { redirect_to @role, notice: 'Role was successfully updated.' }
        format.json { render :show, status: :ok, location: @role }
      else
        format.html { render :edit }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /roles/1
  # DELETE /roles/1.json
  def destroy
    @role.destroy
    respond_to do |format|
      format.html { redirect_to roles_url, notice: 'Role was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_role
      @role = Role.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def role_params
      params.require(:role).permit(:description, :action, :resource)
    end
end
