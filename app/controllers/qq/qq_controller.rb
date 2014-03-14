class Qq::QqController < ActionController::Base

  protect_from_forgery with: :exception

  before_action :set_header_for_qq
  layout "qq/layouts/qq_game"


  before_action :get_platform_info

  private
  def set_header_for_qq
    response.headers["X-Frame-Options"] = "Allow-From http://rc.qzone.qq.com"
  end

  def get_platform_info
    @pf = params[:pf] || "qzone"
    puts @pf
  end


end