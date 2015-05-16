if Rails.env.development?
  redis_host = '127.0.0.1'
else
  redis_host = '121.42.47.121'
end
Sidekiq.configure_server do |config|
  config.redis = {:url => "redis://#{redis_host}:6379/12", :namespace => 'sidekiq'}
end

Sidekiq.configure_client do |config|
  config.redis = {:url => "redis://#{redis_host}:6379/12", :namespace => 'sidekiq'}
end

Sidekiq.default_worker_options = { 'backtrace' => true }