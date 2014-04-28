class Api::ApiController < ActionController::Base

  protect_from_forgery with: :exception

  rescue_from StandardError do |exception|
    new_logger = Logger.new('log/app_api_exceptions.log')
    new_logger.info("THIS IS A NEW EXCEPTION! #{Time.now.to_s}")
    new_logger.info("------ #{request.remote_ip} ------")
    new_logger.info(request.url)
    new_logger.info(params.to_s)
    new_logger.info(exception.message)
    new_logger.info(exception.backtrace.join("\n"))
    raise exception
  end

end