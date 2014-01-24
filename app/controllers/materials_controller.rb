class MaterialsController < ApplicationController

  def index 
    @q = Material.ransack params[:q]
    @materials = @q.result.order('id desc').to_a
  end

  def show
    @material = Material.find params[:id]
    render layout: false
  end

  def return
    @material = Material.find params[:id]
    if request.xhr?
      ERB.new(@material.category.try(:re_js)).result(binding)
      render json: @json
    end
  end

  def ex_share
    #if params[:f]
      #key = "wx_share_#{params[:f]}"
      #@count = $redis.incr(key)
    #end
    render nothing: true
  end

  def result
  end

  def egg
    render layout: false
  end
  def test
    render layout: false
  end
end