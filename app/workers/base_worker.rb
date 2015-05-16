class BaseWorker

  include Sidekiq::Worker
  sidekiq_options :retry => 5,:backtrace => true

  sidekiq_retries_exhausted do |msg|
    Sidekiq.logger.warn "Failed #{msg['class']} with #{msg['args']}: #{msg['error_message']}"
  end

end