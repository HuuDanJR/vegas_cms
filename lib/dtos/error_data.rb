class ErrorData
  attr_reader :status, :error, :exception

  def initialize(status, exception)
    @status = Rack::Utils.status_code(status)
    @error = Rack::Utils::HTTP_STATUS_CODES[@status]
    @exception = exception
  end

end