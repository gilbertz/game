require File.dirname(__FILE__)+'/../../lib/wxcards/wx_cards'
require File.expand_path('../wx_third/wx_util',__FILE__)
class WshowsController < ApplicationController

  def show
    @wshow = Wshow.find params[:id]
    render layout: false
  end

  def custom
     @wshow = Wshow.find params[:id]
     render layout: false 
  end

  def draft
    #@user = User.find_by_token prarams[:token]
    @user = User.find 1
    k = "kk_#{@user.id}"
    @content = $redis.get k
    render layout: false
  end
end
