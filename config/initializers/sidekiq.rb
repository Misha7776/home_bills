redis_cfg = { url: ENV['REDIS_URL'] }

Sidekiq.configure_server do |config|
  config.redis = redis_cfg
  config.log_formatter = Sidekiq::Logger::Formatters::JSON.new
end

Sidekiq.configure_client do |config|
  config.redis = redis_cfg
end