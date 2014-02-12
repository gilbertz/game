class HomeController < ApplicationController

  def index
    @materials = Material.includes(:images).where(state: 1).order('id desc').page(params[:page]).per(9)
  end
end
