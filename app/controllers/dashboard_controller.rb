class DashboardController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  before_action :authorized_user

  def index
    @user_latest = User.order(created_at: :desc).limit(8).offset(0)
    @user_login_latest = User.order(last_sign_in_at: :desc).limit(5).offset(0)
  end
end
