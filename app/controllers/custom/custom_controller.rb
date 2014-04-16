class Custom::CustomController < ActionController::Base

  layout "custom"
  before_filter :login_authenticate, :check_cookie, :except => [:click_stat, :show_stat]
  helper_method :current_user

  def current_user
    @user ||= User.find_by_id session[:admin_user_id]
    @user || redirect_to([:custom,:login])
  end

  def is_login?
    session[:admin_user_id].present?
  end

  private
  def login_authenticate
    unless is_login?
      redirect_to [:custom,:login]
      return
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

  def can?(target)
    current_user.id == target.user_id
  end

end