class MaterialsController < ApplicationController

  def show
    @material = Material.find params[:id]
    render layout: false
  end

  def return
    @material = Material.find params[:id]
    if request.xhr?
      render json: {msg: 'ok' }
    end
  end

  def egg
    render layout: false
  end
  def test
    render layout: false
  end
end
