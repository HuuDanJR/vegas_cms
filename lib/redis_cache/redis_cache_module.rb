module RedisCacheModule
  include HttpModule

  CACHE_ENABLE = ENV['CACHE_ENABLE']
  EXPIRE_TIME = ENV['CACHE_REDIS_EXPIRE_TIME'].to_i

  def redis_cache_get(key)
    value = nil
    if CACHE_ENABLE.to_i == 1
      begin
        value = $redis.get(key)
      rescue StandardError => e
        logger.error e
      end
    end
    return value
  end

  def redis_cache_set(key, value)
    if CACHE_ENABLE.to_i == 1
      begin
        $redis.set(key, value.to_json)
        $redis.expire(key, EXPIRE_TIME.hour.to_i)
      rescue StandardError => e
        logger.error e
      end
    end
  end

  def redis_cache_delete(key)
    if CACHE_ENABLE.to_i == 1
      begin
        if $redis.exists(key)
          $redis.del(key)
        end
      rescue StandardError => e
        logger.error e
      end
    end
  end

  def redis_cache_delete_by_prefix(clazz)
    key = clazz.to_s + '-*'
    if CACHE_ENABLE.to_i == 1
      begin
        $redis.del($redis.keys(key))
      rescue StandardError => e
        logger.error e
      end
    end
  end

  def redis_cache_generate_key_get_all(clazz_filter_params, clazz, action_function)
    prefix = clazz.to_s + '-' + action_function.to_s + '-'
    redis_key_list = []

    redis_key_list.push(filtering_params(params, clazz_filter_params).to_s)
    redis_key_list.push(return_data_param_field(params['fields']))
    redis_key_list.push(return_data_param_order(params['sort']))
    redis_key_list.push(return_data_param_limit(params['limit']).to_s)
    redis_key_list.push(return_data_param_offset(params['offset']).to_s)
    redis_key_list.push(return_data_param_include(params['include']).to_s)

    return prefix + Digest::SHA2.hexdigest(redis_key_list.map(&:inspect).join('-'))
  end

  def redis_cache_generate_key_get_by_id(clazz, action_function)
    prefix = clazz.to_s + '-' + action_function.to_s + '-' + params[:id].to_s + '-'
    redis_key_list = []

    redis_key_list.push(return_data_param_field(params['fields']))
    redis_key_list.push(return_data_param_include(params['include']).to_s)
    redis_key_list.push(params[:id].to_s)

    return prefix + Digest::SHA2.hexdigest(redis_key_list.map(&:inspect).join('-'))
  end

  def redis_cache_generate_key_search_by_radius(clazz_filter_params, clazz, action_function)
    prefix = clazz.to_s + '-' + action_function.to_s + '-'
    redis_key_list = []

    redis_key_list.push(filtering_params(params, clazz_filter_params).to_s)
    redis_key_list.push(return_data_param_field(params['fields']))
    redis_key_list.push(return_data_param_order(params['sort']))
    redis_key_list.push(return_data_param_limit(params['limit']).to_s)
    redis_key_list.push(return_data_param_offset(params['offset']).to_s)
    redis_key_list.push(return_data_param_include(params['include']).to_s)
    redis_key_list.push(return_data_param_number(params['lat']).to_s)
    redis_key_list.push(return_data_param_number(params['lng']).to_s)
    redis_key_list.push(return_data_param_number(params['radius']).to_s)

    return prefix + Digest::SHA2.hexdigest(redis_key_list.map(&:inspect).join('-'))
  end

  def redis_cache_generate_key_search_router(clazz, action_function)
    prefix = clazz.to_s + '-' + action_function.to_s + '-'
    redis_key_list = []

    redis_key_list.push(return_data_param_number(params['place_begin']).to_s)
    redis_key_list.push(return_data_param_number(params['place_end']).to_s)

    return prefix + Digest::SHA2.hexdigest(redis_key_list.map(&:inspect).join('-'))
  end

end