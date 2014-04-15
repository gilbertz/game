class Admin::BaseController < ActionController::Base
  layout 'admin'

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
    l_ip = Socket.ip_address_list.collect{|i| i.ip_address}

    cache_path = "#{Rails.root}/public/materials"
    FileUtils.rm_r(cache_path) if Dir.exist?(cache_path)

    if l_ip.include? "203.195.191.203"
      res = RestClient.get("http://203.195.186.54:4002/admin/home/clear_single_cache/#{material.id}")
    else
      res = RestClient.get("http://203.195.191.203:4002/admin/home/clear_single_cache/#{material.id}")
    end

  end

end
