class Api::V1::OfficersController < Api::V1::BaseController
  skip_before_action :doorkeeper_authorize!, only: [:index, :show] # Requires access token for all actions
  before_action :authenticate_user!, only: [:create, :update]

  include OfficerModule

  def initialize()
    super(OFFICER_ATTRIBUTE)
  end

end