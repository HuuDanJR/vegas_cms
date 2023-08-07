class ApplicationController < ActionController::Base
  # Redirect to 404 page
  def redirect_to_not_found
    respond_to do |format|
      format.json { render :json => {:error => I18n.t('error_404_info')}, :status => :not_found }
      format.html { redirect_to main_app.root_url, alert: I18n.t('error_404_info') }
    end
  end

  # Redirect to 422 page
  def redirect_to_unprocessable
    respond_to do |format|
      format.json { render :json => {:error => I18n.t('error_422_info')}, :status => :not_found }
      format.html { redirect_to main_app.root_url, alert: I18n.t('error_422_info') }
    end
  end

  # Redirect to 500 page
  def redirect_to_500_error
    respond_to do |format|
      format.json { render :json => {:error => I18n.t('error_500_info')}, :status => :internal_server_error }
      format.html { redirect_to main_app.root_url, alert: I18n.t('error_500_info') }
    end
  end

  def authorized_user
    current_user = authenticate_user!
    role = action_name + "_" + controller_name
    return if current_user.role? role
    respond_to do |format|
      format.json { render :json => {:error => I18n.t('error_403_info')}, :status => :forbidden }
      format.html { redirect_to main_app.root_url, alert: I18n.t('error_403_info') }
    end
  end
end
