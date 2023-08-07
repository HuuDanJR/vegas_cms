module Response
  include RedisCacheModule

  def json_response(object, status = :ok, excepted_attributes = [], include_objects = {}, cache_key = nil)
    cache_data = render json: object, status: status, except: excepted_attributes, include: include_objects

    unless cache_key.nil?
      redis_cache_set(cache_key, JSON.parse(cache_data))
    end
  end
end