class Admin::BaseController < ActionController::Base
  layout 'admin'

  before_filter :login_authenticate, :check_cookie 
  helper_method :current_user

  def current_user
     @user ||= User.find_by_id session[:admin_user_id]
     @user || redirect_to([:admin,:login])
  end

  def is_login?
    session[:admin_user_id].present? 
  end

  private
  def login_authenticate 
    redirect_to [:admin,:login] unless is_login?
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
end
