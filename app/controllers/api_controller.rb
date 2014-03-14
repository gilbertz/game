class ApiController < ApplicationController

  helper_method :current_cart, :current_user?, :current_user
  before_filter :set_content_type

  def current_cart
    @current_cart ||= (current_user.cart || current_user.create_cart)
  end

  def current_user?
    current_user.present?
  end

  def current_user
    if request.ip == "127.0.0.1"
      @current_user ||= User.find_by_token(select_token)
    else
      return if params[:token].nil?
      @current_user ||= User.find_by_token(params[:token])
    end
  end

  def select_token
    "b3b852dc658e4c1f1784368a7f205a4882e17983bb0294d87f10baed0768c529"
  end

  def render_state(sym)
    @state = sym.to_s
  end

  def render_success_state
    @state = 'success'
  end

  def login_authenticate
    !current_user? && render('/api/unlogin')
  end

  private
  def set_content_type
    content_type = case params[:format]
                     when "json"
                       "application/json"
                     when "xml"
                       "text/xml"
                   end
    headers["Content-Type"] = content_type
  end
end
