namespace = ENV['REDIS_NAMESPACE'] || ''
Redis.current = Redis::Namespace.new(namespace, redis: Redis.new(url: ENV['REDIS_URI']))
