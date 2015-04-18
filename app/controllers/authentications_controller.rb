# -*- encoding : utf-8 -*-
class AuthenticationsController < Devise::OmniauthCallbacksController
  def sign_in_or_redirect
    if params[:rurl]
      sign_in @user 
      redirect_to params[:rurl]
    else
      sign_in_and_redirect @user
    end
  end


  def weixin
    cookies[:l] = { :value => "#{Time.now.to_i}", :expires => 10.year.from_now }

    auth = request.env['omniauth.auth']
    print auth
    redirect_to root_path if auth.blank?
    @user=nil
    @user=Authentication.find_from_hash(auth)
    if(@user)
      print @user
      print "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
      raw_info = auth['extra']['raw_info']
      p raw_info['city'], auth["info"], auth["info"]["image"], raw_info["sex"], raw_info["language"], raw_info["province"], raw_info["city"], raw_info["country"]
      @auth_hash = {:name=>auth["info"]["name"], :sex=>raw_info["sex"], :language=>raw_info["language"], :province=>raw_info["province"], :city=>raw_info["city"], :country=>raw_info["country"], :profile_img_url=>auth["info"]["image"]} 
      @user.update_attributes( @auth_hash )
      #cookies[:userid] = { :value => "#{@user.id}", :expires => 10.year.from_now }
      update_rememberme_token(@user)
      sign_in_or_redirect
    else
      @username="fk"+Devise.friendly_token[0,20]
      @email=@username+"@dapeimishu.com"
      @password=Devise.friendly_token[0,12]
      @auth_hash = {:name=>auth["info"]["name"], :email=>@email, :password=>@password, :sex=>auth["info"]["sex"], :language=>auth["info"]["language"], :province=>auth["info"]["province"], :city=>auth["info"]["city"], :country=>auth["info"]["country"],  :remember_me=>1, :desc=>auth["info"]["description"],
        :profile_img_url=>auth["info"]["image"]}
      @user = User.new( @auth_hash )
      p @user
      if @user.save
        @user=Authentication.create_from_hash(auth, @user)
        #print @user
        #print @user.errors.full_messages
        #cookies[:userid] = { :value => "#{@user.id}", :expires => 10.year.from_now }
        update_rememberme_token(@user)
        sign_in_or_redirect
        #redirect_to "/"
      else
        redirect_to "/"
      end
    end
  end

private
  def update_rememberme_token(user)
    session[:admin_user_id] = user.id
    user.update_rememberme_token
    cookies.signed[:remember_me] = {
        value:  user.rememberme_token,
        expires: 14.day.from_now.utc
    }
  end


end
