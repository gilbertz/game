class Qq::QqController < ActionController::Base

  protect_from_forgery with: :exception

  before_action :set_header_for_qq
  layout "qq/layouts/qq_game"

  private
  def set_header_for_qq
    response.headers["X-Frame-Options"] = "Allow-From http://rc.qzone.qq.com"
  end

end