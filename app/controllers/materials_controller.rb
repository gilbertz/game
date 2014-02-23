class MaterialsController < ApplicationController

  def index 
    @materials = Material.includes(:images).where(state: 1).order('id desc').page(params[:page]).per(12)
    render json: {content: @materials, href: "/materials?page=#{params[:page].to_i + 1}"}
  end

  def show
    get_topn

    @material = Material.find params[:id]
    unless params[:text]
      render layout: false
    else
      render 'show_ncache', layout: false
    end
  end

  def return
    @material = Material.find params[:id]
    if request.xhr?
      ERB.new(@material.category.try(:re_js)).result(binding)
      render json: @json
    else
      render layout: false
    end
  end

  def iqtest
    render layout: false
  end

  def jiu_gong
    render layout: false
  end

  def wx_share
    #if params[:f]
      #key = "wx_share_#{params[:f]}"
      #@count = $redis.incr(key)
    #end
    render nothing: true
  end

  def report
    if params[:game_id] and params[:score]
      key = "score_#{params[:game_id]}_top"
      $redis.zadd(key, params[:score].to_i * -1, params[:score])
       
      if $redis.zcard(key) > 10
        $redis.zremrangebyrank(key, -1, -1)
      end
    end
    render nothing: true
  end
  

  def get_topn
    begin
      key = "score_48_top"
      @topn = $redis.zrange(key, 0, 9)
    rescue =>e
      p e.to_s
    end
  end

  def egg
    render layout: false
  end

  def test
    render layout: false
  end
end
