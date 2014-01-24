class HomeController < ApplicationController

  def index
    @q = Material.ransack params[:q]
    @materials = @q.result.order('id desc').to_a
  end

  def search
    @q = Material.ransack params[:q]
    @materials = @q.result.order('id desc').to_a
  end
end
