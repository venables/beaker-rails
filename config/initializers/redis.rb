redis = Redis.new(url: ENV['REDIS_URI'])

if ENV['REDIS_NAMESPACE']
  redis = Redis::Namespace.new(ENV['REDIS_NAMESPACE'], redis: redis)
end

Redis.current = redis
