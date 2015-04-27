class Admin::BaseController < ActionController::Base
  layout 'admin'
  
  # http_basic_authenticate_with :name => 'zhurun888', :password => 'zhuxiaolang'
  Object_types = [["无",""], ["红包", "redpack"], ["卡券", "card"], ["游戏", "bgame"]]

  rescue_from StandardError do |exception|
    new_logger = Logger.new('log/admin_exceptions.log')
    new_logger.info('THIS IS A NEW EXCEPTION!')
    new_logger.info(request.url)
    new_logger.info(params.to_s)
    new_logger.info(exception.message)
    raise exception
  end

  before_filter :login_authenticate, :check_cookie, :except => [:click_stat, :show_stat]
  helper_method :current_user

  def current_user
     @user ||= User.find_by_id session[:admin_user_id]
     @user || redirect_to([:admin,:login])
  end

  def is_login?
    session[:admin_user_id].present?
  end

  def is_admin?
    current_user.role == 1
  end

  private
  def login_authenticate 
    unless is_login?
      redirect_to [:admin,:login]
      return
    end

    unless is_admin?
      redirect_to "/"
    end
  end

  def check_cookie
    if cookies[:remember_me].present?
      unless is_login?
        if cookies.signed[:remember_me].present? 
          user = User.find_by_rememberme_token cookies.signed[:remember_me]
          if user && user.rememberme_token == cookies.signed[:remember_me]  
            session[:admin_user_id] = user.id  
          end
        end
      end
    end
  end

  def clear_page(material)
    expire_page "/weitest/#{material.url}"   

 
    #l_ip = Socket.ip_address_list.collect{|i| i.ip_address}
    #expire_page "/materials/#{material.id}"
    #expire_page "/materials/#{material.id}/fr/ios"
    #expire_page "/materials/#{material.id}/fr/andriod"

    #if l_ip.include? "203.195.191.203"
    #  res = RestClient.get("http://203.195.186.54:4002/admin/home/clear_single_cache/#{material.id}")
    #else
    #  res = RestClient.get("http://203.195.191.203:4002/admin/home/clear_single_cache/#{material.id}")
    #end

  end

end
