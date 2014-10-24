class WcardsController < ApplicationController
  #caches_page :show
  def show
    @wcard = Wcard.find params[:id]
    render layout: false
  end

  def custom
    render layout: false
  end
end
