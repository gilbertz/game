class Admin::SessionController < Admin::BaseController
  skip_filter :login_authenticate

  def new
  end

  def create
    if user = User.auth(params[:name], params[:password]) 
      session[:admin_user_id] = user.id
      if params[:rememberme].present? && params[:rememberme] == "1"
        user.update_rememberme_token 
        cookies.signed[:remember_me] = {   
          value:  user.rememberme_token,
          expires: 7.day.from_now.utc 
        }
      end
      redirect_to [:admin,:materials]
    else
      redirect_to [:admin,:login]
    end
  end

  def destroy
    cookies.delete(:remember_me)
    session[:admin_user_id] = nil 
    redirect_to [:admin,:login]
  end
end
