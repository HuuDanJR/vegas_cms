$redis = Redis.new(
    host: ENV['CACHE_REDIS_IP'],
    port: ENV['CACHE_REDIS_PORT'],
    timeout: ENV['CACHE_REDIS_TIMEOUT'],
    password: ENV['CACHE_REDIS_PASSWORD'])
