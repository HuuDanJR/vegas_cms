class OfficerImportsController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  before_action :authorized_user

  include RedisCacheModule

  # GET /officer_import/new
  def new
    @officer_import = OfficerImport.new
  end

  # POST /officer_import
  def create
    if params[:officer_import].nil?
      redirect_to :new_officer_import, alert: t(:file_import_not_found)
    else
      @officer_import = OfficerImport.new(params[:officer_import])
      if @officer_import.save
        # Clear cache
        redis_cache_delete_by_prefix(Officer)

        redirect_to officers_path, notice: t(:file_import_success)
      else
        redirect_to :new_officer_import, alert: t(:error_500_info)
      end
    end
  end
end
