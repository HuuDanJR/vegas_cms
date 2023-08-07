module ErrorHandler
  extend ActiveSupport::Concern

  class AuthenticationError < StandardError; end
  class MissingToken < StandardError; end
  class InvalidToken < StandardError; end
  class NotFound < StandardError; end
  class InvalidJson < StandardError; end

  included do
    rescue_from ErrorHandler::NotFound, with: :record_not_found
    rescue_from ErrorHandler::AuthenticationError, with: :unauthorized_request
    rescue_from ErrorHandler::MissingToken, with: :unauthorized_request
    rescue_from ErrorHandler::InvalidToken, with: :unauthorized_request
    rescue_from ErrorHandler::InvalidJson, with: :invalid_json

    rescue_from ActiveRecord::RecordNotFound do |e|
      json_response(ErrorData.new(:not_found, e.message), :not_found)
    end
  end

  private

  def record_not_found(exception)
    json_response(ErrorData.new(:not_found, exception), :not_found)
  end

  def unauthorized_request(exception)
    json_response(ErrorData.new(:unauthorized, exception), :unauthorized)
  end

  def invalid_json(exception)
    json_response(ErrorData.new(:bad_request, exception), :bad_request)
  end
end