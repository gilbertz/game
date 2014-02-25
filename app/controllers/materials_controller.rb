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
      key1 = "score_#{params[:game_id]}_recent"     
 
      if params[:score].length < 10 and params[:score].to_i < 100000
         $redis.zadd(key, params[:score].to_i * -1, params[:score])
         $redis.lpush(key1, params[:score])
      end
      $redis.zrem(key, "783272881145583")
      $redis.zrem(key, "4255367378012730") 
      $redis.zrem(key, "999999") 
      if $redis.zcard(key) > 20
        $redis.zremrangebyrank(key, -1, -1)
      end
      if $redis.zcard(key1) > 20
        $redis.rpop(key1)
      end
    end
    render nothing: true
  end
  

  def get_topn
    begin
      key = "score_48_top"
      key1 = "score_48_recent"
      @topn = $redis.zrange(key, 0, 9)
      @recentn = $redis.lrange(key1, 0, 9)
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
