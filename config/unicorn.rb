# If you have a very small app you may be able to
# increase this, but in general 3 workers seems to
# work best
worker_processes ENV['RAILS_ENV'] == 'development' ? 1 : 3

# Load your app into the master before forking
# workers for super-fast worker spawn times
preload_app true

# Immediately restart any workers that
# haven't responded within 30 seconds
timeout 30

before_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
    Rails.logger.info('Disconnected from ActiveRecord')
  end

  #if defined?(Resque)
    #Resque.redis.quit
    #Rails.logger.info('Disconnected from Redis')
  #end
end

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing.'
    puts 'Wait for master to sent QUIT'
  end

  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
    Rails.logger.info('Connected to ActiveRecord')
  end

  #if defined?(Resque)
    #Resque.redis = ENV['REDIS_URI']
    #Rails.logger.info('Connected to Redis')
  #end
end
