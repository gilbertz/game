class WcardsController < ApplicationController
  #caches_page :show
 
  def gouhai
    @wcard = Wcard.find 10
    @game = Material.find_by_url(params[:gurl])
    render :show,  layout: false
  end

  def show
    @wcard = Wcard.find params[:id]
    render layout: false
  end

  def custom
    render layout: false
  end
end
