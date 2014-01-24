class HomeController < ApplicationController

  def index
    @q = Material.includes(:images).ransack params[:q]
    @materials = @q.result.order('id desc')
  end

  def search
    @q = Material.ransack params[:q]
    @materials = @q.result.order('id desc')
  end
end
