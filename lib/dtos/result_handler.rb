class ResultHandler
  attr_reader :result, :status, :data, :exception

  def initialize()
    @result = true
    @status = Rack::Utils.status_code(:ok)
    @data = []
    @exception = ""
  end

  def set_success_data(status, data)
    @result = true
    @status = Rack::Utils.status_code(status)
    @data = data
  end

  def set_success_data_paging(status, data, total)
    @result = true
    @status = Rack::Utils.status_code(status)
    @data = PagingDto.new(data, total)
  end

  def set_error_data(status, exception)
    @result = false
    @status = Rack::Utils.status_code(status)
    @exception = exception
  end

  private
  class PagingDto
    attr_reader :data, :meta
    def initialize(_data, _total)
      @data = _data
      @meta = {
          "total" => _total
      }
    end
  end
end