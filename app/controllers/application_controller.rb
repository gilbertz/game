class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from StandardError do |exception|
    new_logger = Logger.new('log/exceptions.log')
    new_logger.info('THIS IS A NEW EXCEPTION!')
    new_logger.info(request.url)
    new_logger.info(params.to_s)
    new_logger.info(exception.message)
    raise exception
  end


end
