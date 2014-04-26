# encoding: utf-8
class MaterialsController < ApplicationController

  skip_before_filter :verify_authenticity_token, :only => [:result]

  def result
    unless params[:material_id].blank?

      @material = Material.find(params[:material_id])

      res = [201510, 197631, 197661, 199981, 201516, 200793, 197649, 197666, 197673, 200786]

      user_res = []

      user_res << params["81113"].to_i << params["80015"].to_i << params["80020"].to_i << params["80714"].to_i << params["81114"].to_i
      user_res << params["80018"].to_i << params["80021"].to_i << params["80022"].to_i << params["80863"].to_i << params["80864"].to_i

      result = user_res & res
      r =result.size
      @zhishang = 60 + (14*(r-1)) + rand(14)

      if r < 2
        @message = "动脑臣妾做不到啊"
      elsif r < 4
        @message = "很傻很天真"
      elsif r < 6
        @message = "天然呆自然萌"
      elsif r < 8
        @message = "聪明伶俐"
      elsif r < 10
        @message = "智力是极好的"
      elsif r < 11
        @message = "爱因斯坦级别的"
      end

      @people = ((@material.pv.to_i * 0.1 * r) + rand(@material.pv.to_i/100)).floor
      @referer = request.referer

      m = "material"
      m << params[:material_id]
      render :template => "materials/#{m}", :layout => false
    end
  end

  def index
    cond = "1=1"
    cond += " and `category_id` = #{params[cid]}" if params[:cid]
    cond += " and `categories`.`game_type_id` = #{params["game_type_id"]}" unless params["game_type_id"].blank?
    materials = Material.includes(:images).joins(:category).where(cond).where(state: 1)

    unless params[:order].blank?
        if params[:order] == "hot"
          materials = materials.order('redis_pv desc')
        elsif params[:order] == "recommend"
          materials = materials.order('redis_wx_share_pyq desc')
        end
    else
      materials = materials.order('materials.id desc')
    end

    @materials = materials.page(params[:page]).per(12)
    render json: {content: @materials, href: "/materials?page=#{params[:page].to_i + 1}&game_type_id=#{params["game_type_id"]}&order=#{params["order"]}"}
  end

  def hello_test
    render :layout => false
  end


  def rand_wid
    wx_ids = ['wx8820cdf5db680ffa', 'wxf37239efdb6106b8', 'wx333eb5e8a7d7a4b7', 'wx1fd508e23f093612', 'wx78f81724e6590b1d', 'wx14db6de757190903', 'wx843a75276b087b5b', 'wxa4b43775687cda90', 'wx3fb66635e78c1d91']
    len = wx_ids.length
    wx_ids[rand(len)]
  end


  def rand_domain
    wx_domains = ['http://g.shangjieba.com', 'http://g.saibaobei.com', 'http://wx.mna.myqcloud.com', 'http://wanhuir.mna.myqcloud.com' ]
    len = wx_domains.length
    wx_domains[rand(len)]
  end

  #caches_page :show
  def show
    ua = request.user_agent.downcase
    @wx_id = "wx7786f97ea666be3c"
    @wx_domain = rand_domain
    if ua.index("micromessenger")
      @wx_id = rand_wid 
    end

    @material = Material.find params[:id]

    @base_category = Category.find(1)
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
      key = "wx_gshare_#{params[:f]}"
      $redis.incr(key)
      gid = params[:f].gsub(/(.*?)(\d+)/, '\2')
      game = Material.find(gid)
      if game
        cid = game.category_id
        if cid
          ckey = "wx_cshare_#{params[:f]}"
          ckey = ckey.gsub(gid.to_s, cid.to_s)
          $redis.incr(ckey)
        end
      end
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
    Ad.where(:on => true).where("t < 3").each do |ad|
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
