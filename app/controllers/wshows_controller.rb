class WshowsController < ApplicationController
  def show
    @wshow = Wshow.find params[:id]
    render layout: false
  end

  def custom
     @wshow = Wshow.find params[:id]
     render layout: false 
  end
end
