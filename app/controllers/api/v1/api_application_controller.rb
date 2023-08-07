class Api::V1::ApiApplicationController < ActionController::API
  before_action :doorkeeper_authorize! # Requires access token for all actions

  include Response
  include ErrorHandler
  include CommonModule

  # Customize authenticate user
  def authenticate_user!
    if doorkeeper_token
      Thread.current[:current_user] = User.find doorkeeper_token.resource_owner_id
    end
    return if current_user
    render json: {errors: ["User is not authenticated!"]}, status: :unauthorized
  end

  # Get current user
  def current_user
    Thread.current[:current_user]
  end

  # Check request body
  def check_request_body
    @request_body = request.body.read
    begin
      @request_body = JSON.parse(@request_body)
      if @request_body.empty?
        raise ErrorHandler::InvalidJson, I18n.t('messages.input_json_invalid')
      end
    rescue
      raise ErrorHandler::InvalidJson, I18n.t('messages.input_json_invalid')
    end
  end

  protected

  # attr_reader :current_user

  # Render error json
  def render_error_json(error_data)
    json_response(error_data, error_data.status)
  end

  # Render success json
  def render_success_json(success_data, excepted_attributes = [], include_objects = {}, cache_key = nil)
    json_response(success_data.data, success_data.status, excepted_attributes, include_objects, cache_key)
  end
end