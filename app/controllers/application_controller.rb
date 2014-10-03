class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_filter :set_weixin_config

  protect_from_forgery with: :exception

  rescue_from StandardError do |exception|
    new_logger = Logger.new('log/exceptions.log')
    new_logger.info("THIS IS A NEW EXCEPTION! #{Time.now.to_s}")
    new_logger.info("------ #{request.remote_ip} ------")
    new_logger.info(request.url)
    new_logger.info(params.to_s)
    new_logger.info(exception.message)
    new_logger.info(exception.backtrace.join("\n"))
    raise exception
  end

  
private
  def set_weixin_config
    wx_config = WxConfig.find 1
    @set_wx_ad = wx_config.wx_ad
  end


end
