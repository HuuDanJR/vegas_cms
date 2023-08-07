class SuccessData
  attr_reader :status, :data

  def initialize(status, data)
    @status = Rack::Utils.status_code(status)
    @data = data
  end
end