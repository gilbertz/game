class Custom::SessionController < Custom::CustomController
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
          expires: 3.day.from_now.utc 
        }
      end
      redirect_to [:custom,:root]
    else
      redirect_to [:custom,:login]
    end
  end

  def destroy
    cookies.delete(:remember_me)
    session[:admin_user_id] = nil 
    redirect_to [:custom,:login]
  end
end
