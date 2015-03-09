# ncoding: utf-8
class WeitestController < ApplicationController

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
    #render json: {content: @materials, href: "/materials?page=#{params[:page].to_i + 1}&game_type_id=#{params["game_type_id"]}&order=#{params["order"]}"}
  end

  def hello_test
    render :layout => false
  end


  def rand_wid
    #wx_ids =['wx86433051a3453fdc', 'wx2c20339cc2a325dd', 'wx2a4b8a6bdfac9c63', 'wx8367f6d381f5e426', 'wxe6404e40db3e670f', \
#'wxd78ec510ab961060', 'wx4a640669f5e0e603', 'wx4a640669f5e0e603', 'wxfce0da8b4f0a0003', 'wxbbb403df2d1a02c8', 'wx223cf4a8d00f3d8b', 'wx2dc01e002752dacb', 'wx7a4afeaba4f9b1a5']
    #wx_ids += ['wx8d92ca1243a4d947', 'wx8fed61e0d05c5732', 'wx7786f97ea666be3c', 'wx8820cdf5db680ffa', 'wxf37239efdb6106b8', 'wx333eb5e8a7d7a4b7', 'wx1fd508e23f093612', 'wx78f81724e6590b1d', 'wx14db6de757190903', 'wx843a75276b087b5b', 'wxa4b43775687cda90', 'wx3fb66635e78c1d91']
    

    wx_ids = ['wx78f81724e6590b1d', 'wx14db6de757190903', 'wx843a75276b087b5b', 'wxa4b43775687cda90', 'wx3fb66635e78c1d91', 'wx6a7bb35a163404cd', 'wxe750bcfd9dbce2d5', 'wx219c5849ac75b3eb', 'wx22f19a668186d05e', 'wx798d5736fef68eac', 'wx2babddd351826991', 'wx5f8a031de25eb179', 'wx80f3dadb401b24e', 'wx9b54843d34112fc8', 'wxe70cffc9973f7705', 'wxc52e77b511eae288', 'wxdd3e820193c3c4bc', 'wx0a4c0018c920674e']
    #weixins = Weixin.where(:active => true)
    #wx_ids = weixins.map{|wx|wx.wxid}
    len = wx_ids.length
    wx_ids[rand(len)]
    #wx_ids[ params[:id].to_i % len ] 
  end


  def rand_domain
    #wx_domains = ['http://app.shangjieba.com', 'http://app.weixinjie.net', 'http://app.saibaobei.com', 'http://wan.mna.myqcloud.com', 'http://g.leapcliff.com', 'http://g.weixinjie.net', 'http://g.shangjieba.com', 'http://g.saibaobei.com', 'http://wx.mna.myqcloud.com', 'http://wanhuir.mna.myqcloud.com' ]
   
    #wx_domains = ['http://ggb.bbdd08.cn', 'http://wwmxd.kmtuan.cn', 'http://cool.syhly.cn', 'http://abcdefg.gmzzzl.cn', 'http://ggb.ntjcdx.com', 'http://wei.51self.com', 'http://xsd.xcsgs.com' ]
    wx_domains = ['http://ggb.bbdd08.cn', 'http://wwmxd.kmtuan.cn', 'http://abcdefg.gmzzzl.cn', 'http://ggb.ntjcdx.com', 'http://wei.51self.com' ]
    #domains = Domain.where(:active => true).where(:tid => 2)
    #wx_domains = domains.map{|d|d.get_name}   
 
    len = wx_domains.length
    wx_domains[rand(len)]
    #wx_domains[ params[:id].to_i % len ] 
  end

  
  def rand_weixin
    @wx_id = "wx22f19a668186d05e"
    @wx_domain = "http://wei.51self.com"
    @sid = 0
    @option = ''
    @sc = 1
    @dd = Time.now.strftime("v%y%m%d")
    #@dd = ('a'..'z').to_a.shuffle[0..3].join 

    if params[:sc]
      $redis.incr("share_count_#{params[:id]}_#{params[:sc]}")
      @sc = params[:sc].to_i + 1
    end

    if params[:wid]
      $redis.incr("weixin_#{params[:wid]}")
    end
   
    if params[:did]
      $redis.incr("domain_#{params[:did]}")
    end

    weixins = Weixin.where(:active => true)
    domains = Domain.where(:active => true).where(:tid => 0)
    
    rand_weixin = weixins.sample(1)[0] 
    rand_domain = domains.sample(1)[0]
   
    @wx_id = rand_weixin.wxid
    @wx_domain = rand_domain.get_name
    #@wx_domain = "http://1.sh.1251225143.clb.myqcloud.com" 
 
    @option = "?wid=#{rand_weixin.id}&did=#{rand_domain.id}&sc=#{@sc}"
  end


  #caches_page :show
  def show
    #ua = request.user_agent.downcase
    #p ua
    @is_weixin = true
    @is_stat = true

    #if ua.index("micromessenger")
    #  @is_weixin = true 
    #  @wx_id = rand_wid
    #  @wx_domain = rand_domain 
    #  @is_stat = true
    #end

    rand_weixin

    #@material = Material.find_by_url params[:id]
    @material = Material.by_hook params[:id]

    #@material.wx_ln = 'http://mp.weixin.qq.com/s?__biz=MzA4NTkwNTIxOQ==&mid=201004496&idx=1&sn=c3dcb0820a5c3746991de7de63429fc8#wechat_redirect'
    #@material.wx_ln = "http://mp.weixin.qq.com/s?__biz=MzA3MDk0MzMxNQ==&mid=200586729&idx=1&sn=599156aecedbfa9317785390ddb0b448#wechat_redirect"
    #@material.wx_ln = "http://mp.weixin.qq.com/s?__biz=MjM5NjIzOTE2OQ==&mid=200366500&idx=1&sn=21c2832b5382e6aafd4e55a0d6c85f5f#wechat_redirect"
    #@material.wx_ln = "http://share.51self.com"
    
    #@material.wx_ln = "http://mp.weixin.qq.com/s?__biz=MzAwNjExMzk1Mg==&mid=200917206&idx=1&sn=284ce5d49ae72daf9bf4c8fefa54ee88#wechat_redirect"
    #@material.wx_ln = "http://mp.weixin.qq.com/s?__biz=MjM5NjIzOTE2OQ==&mid=200366500&idx=1&sn=21c2832b5382e6aafd4e55a0d6c85f5f#wechat_redirect"
    #@material.wx_ln = 'http://mp.weixin.qq.com/s?__biz=MzAwNjExMzk1Mg==&mid=200727692&idx=1&sn=486772b0aa019ee35b2c1d628df8a9ad#wechat_redirect'
   
    @material.wx_ln = 'http://mp.weixin.qq.com/s?__biz=MzAxOTE1MzQ3Ng==&mid=203971151&idx=1&sn=5f6daddfd553757fa640e10b683adad4#wechat_redirect'

    @game_url = @material.url
    hook = Hook.find_all_by_material_id(@material.id).last
    if hook
      @game_url = hook.url
      @material.url = @game_url 
    end 

 
    if @material.category
      unless @material.category.game_type_id >= 13
        @base_category = Category.find(9)
        get_topn(@material.category_id)
        render layout: false
      else
        render 'show_new', layout: false
      end
    else
      render 'static', layout: false
    end
  end

  def return
    @material = Material.by_hook params[:id]
    if request.xhr?
      ERB.new(@material.category.try(:re_js)).result(binding)
      render json: @json
    else
      unless @material.category.game_type_id >= 13
        render layout: false
      else
        render 'return_new', layout: false
      end
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
      gurl = params[:f].gsub(/(.*?)(\d+)/, '\2')
      game = Material.by_hook(gurl) 
      
      if game and params[:r] and params[:r] != '-1'
        akey = "g#{gurl}_#{params[:r]}"
        $redis.incr(akey)
      end
      if game
        cid = game.category_id
        if cid
          ckey = "wx_cshare_#{params[:f]}"
          ckey = ckey.gsub(gurl.to_s, cid.to_s)
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

    if params[:wx_id]
        key = "wx_id_#{params[:wx_id]}"
        $redis.incr(key)
    end

    if params[:wx_domain]
        key = "wx_domain_#{params[:wx_domain]}"
        $redis.incr(key)
    end

    #include ad show stat
    Ad.where(:on => true).where("t < 3").each do |ad|
      key = "ad_show_#{ad.id}"
      $redis.incr(key)
    end
    render :nothing => true
  end
   
  def click_stat
    id = params[:id]
    key = "ad_click_#{id}"
    $redis.incr(key)
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
