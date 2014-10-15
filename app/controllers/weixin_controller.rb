# -*- encoding : utf-8 -*-
require 'rest_client'
require 'json'

class WeixinController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :check_weixin_legality, :only => [:show, :create]
  before_filter :initialize 
 
  def show
    render :text => params[:echostr]
  end


  def create
    p params
    if params[:xml][:MsgType] == "event"
    end
    if params[:xml][:MsgType] == "text"
      render "echo", :formats => :xml
    end

    if params[:xml][:MsgType] == "location"
      @lat = params[:xml][:Location_X]
      @lng = params[:xml][:Location_Y]
    end
  end


  private

  def check_weixin_legality
    array = [@weixin_token, params[:timestamp], params[:nonce]].sort
    render :text => "Forbidden", :status => 403 if params[:signature] != Digest::SHA1.hexdigest(array.join)
  end
  
  def initialize
    @weixin_token = 'xiaojunzhu'
  end
end
