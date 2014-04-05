class MaterialsController < ApplicationController

  def index
    cond = "1=1"
    cond = "category_id = #{params[cid]}" if params[:cid]
    @materials = Material.includes(:images).where(cond).where(state: 1).order('id desc').page(params[:page]).per(12)
    render json: {content: @materials, href: "/materials?page=#{params[:page].to_i + 1}"}
  end

  def hello_test
    render :layout => false
  end

  caches_page :show
  def show
    @material = Material.find params[:id]
    get_topn(@material.category_id)

    render layout: false
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
    if params[:f]
      key = "wx_share_#{params[:f]}"
      @count = $redis.incr(key)
    end
    render nothing: true
  end

  def report
    params[:game_id] = params[:category_id] if params[:category_id]
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
      $redis.zrem(key, "99999")
      if $redis.zcard(key) > 20
        $redis.zremrangebyrank(key, -1, -1)
      end
      if $redis.llen(key1) > 20
        $redis.rpop(key1)
      end
    end
    render nothing: true
  end

  def stat
    if params[:type] and params[:cid]
        key = "stat_#{params[:type]}_#{params[:cid]}"
        $redis.incr(key) 
    end
    if params[:type] and params[:gid]                                              
        key = "gstat_#{params[:type]}_#{params[:gid]}"                               
       $redis.incr(key)                                                            
    end

    #include ad show stat
    Ad.where(:on => true).each do |ad|
      key = "ad_show_#{ad.id}"
      $redis.incr(key)
    end
    render :nothing => true
  end
   

  def get_topn(cid)
    begin
      @topn = []
      @recentn = []
      if cid == 66
        cid = 48
      end
      key = "score_#{cid}_top"
      key1 = "score_#{cid}_recent"
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
