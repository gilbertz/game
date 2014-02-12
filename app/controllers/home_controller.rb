class HomeController < ApplicationController

  def index
    @materials = Material.includes(:images).where(state: 1).order('id desc').page(1).per(9)
  end
end
