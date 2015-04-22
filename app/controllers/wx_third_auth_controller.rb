class WxThirdAuthController < ApplicationController
  skip_before_filter :verify_authenticity_token
  def componentVerifyTicket
    p params
    puts "componentVerifyTicket"
    
    render :text => "success"
		
  end


end
