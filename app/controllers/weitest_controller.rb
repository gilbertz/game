# encoding: utf-8
class WeitestController < ApplicationController
  before_filter :weixin_authorize, :only => [:o2o]
  before_filter :pre

  def weixin_check

    if Check.check_per_day(current_user.id,params[:game_id])<3
      #p Check.check_per_day(current_user.id,params[:game_id])
      beaconid = Ibeacon.find_by(:url=>params[:beaconid]).id
      Check.create(user_id: current_user.id, beaconid: beaconid, state: 1,game_id: params[:game_id]) unless Check.check_state(current_user.id, params[:game_id]) > 0
      render :status => 200, json: {'info' => 1}
    else #Record.redpack_per_day(current_user.id, params[:game_id]) == 3
      # 今天次数用完了
      render :status => 200, json: {'info' => 0}
    end 
  end

  # 今天有记录 从点的人的allocation拿出一定score存储，不存allocation
  # 今天没记录 判断是否在车上，如是，则从redpacktime.min max 取allocation,再取score发出weixin——post，如果不在车上，从点的人的allocation拿出一定score存储在allocation里，再从其中拿出score存储
  #@rp = Redpack.find_by(beaconid: beaconid).weixin_post(current_user, params[:beaconid],record_score).to_i
  def social_redpack
    beaconid = @beacon.id
    total_score = UserScore.find_by("user_id = ? and beaconid = ?", current_user.id, beaconid).total_score  
    if(total_score >= 100)
      Score.create(:user_id => current_user.id, :from_user_id => current_user.id, :beaconid=> beaconid, :value => -total_score, :game_id => params[:game_id])
      UserScore.find_by("user_id = ? and beaconid = ?", current_user.id, beaconid).update(:total_score => 0) 
      Record.create(:user_id => current_user.id, :from_user_id => current_user.id, :beaconid=> beaconid, :game_id => params[:game_id], :score => -total_score, :object_type=> 'social_redpack', :object_id => @object.id)
      total_score = total_score > 300 ? 300 : total_score

      Redpack.find(@object.id).weixin_post(current_user,params[:beaconid],total_score)

      current_user.mark_scores(beaconid, @material.id)
    end
    render :status => 200, json: {'info' => total_score}
  end

  def seed_redpack
   if Check.check_per_day(current_user.id,params[:game_id]) <= 3
    beaconid = @beacon.id
    check = Check.find_by(user_id: current_user.id, beaconid: beaconid,state: 1,game_id: params[:game_id])
    check.update(:state => 0) if check
    info = Redpack.gain_seed_redpack(current_user.id, params[:game_id], @object, @beacon.id)
    Redpack.find(@object.id).weixin_post(current_user,params[:beaconid],info) if info >100
    render :status => 200, json: {'info' => info}
    else # Record.redpack_per_day(current_user.id, params[:game_id]) == 3
      info = 0
      # 今天次数用完了
      render :status => 200, json: {'info' => info}
    end 
  end

  def bus_allocation
    if Record.redpack_per_day(current_user.id, params[:game_id]) < 3
      info = Redpack.first_allocation(current_user.id, params[:game_id], @object,params[:beaconid])
      render :status => 200, json: {'info' => info}
    elsif Record.redpack_per_day(current_user.id, params[:game_id]) == 3
      info = 0
      render :status => 200, json: {'info' => info}
    end 
  end

  def not_bus_allocation
    if Record.redpack_per_day(current_user.id, params[:game_id]) < 2
      Redpack.share_allocation(current_user.id, params[:openid], params[:game_id], @object)
      render :status => 200, json: {'info' => "不在公交也有红包"}
    elsif Record.redpack_per_day(current_user.id, params[:game_id]) ==2
      render :status => 200, json: {'info' => "今天次数用完"}
    end 
  end


  #caches_page :show
  def show
    @material.wx_ln = 'http://51self.com/weitest/1203611402'
    if @material.category
      unless @material.category.game_type_id >= 12
        render layout: false
      else
        render 'show_new', layout: false
      end
    else
      render 'static', layout: false
    end
  end


  def o2o
    if @material.category
      if params[:debug]
        render 'o2o1', layout: false   
      else
        render 'o2o', layout: false
      end
    end
  end


  def return
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

  def weixin_redpack
    if current_user and not @record
      beaconid = @beacon.id
      rp = Redpack.where(beaconid: beaconid,:state =>1).order("start_time desc")[0]
      @rp = rp.weixin_post(current_user, params[:beaconid]).to_i
      Record.create(:user_id => current_user.id, :beaconid=>beaconid, :game_id => params[:game_id], :score => @rp, :object_type=>'Redpack', :object_id => rp.id)
      render :status => 200, json: {'rp' => @rp}
    else
      render :status => 200, json: {'result' => 'not current_user or record' }
    end 
  end

  def weixin_score
    if current_user
      f_value = 0
      beaconid = @beacon.id
      if params[:openid]
        au = Authentication.find_by_uid( params[:openid] )
        if au
          from_user_id = au.user_id
          from_user = User.find from_user_id
          if params[:beaconid] == 'dgbs'
            @score = Score.find_by(:beaconid=>beaconid, :from_user_id =>au.user_id, :user_id =>current_user.id) 
            if not @score and from_user.social_value(beaconid) > 0
              r = Record.find_by(:beaconid=>beaconid, :user_id =>au.user_id)
              f_value = (r.score/2 < 100)?100:r.score/2 if r
              from_user.decr_social(beaconid)
              if from_user.social_value(beaconid) == 0
                rp = Redpack.where(beaconid: beaconid, state: 1).order("start_time desc")[0]
                @rp = rp.weixin_post(from_user, params[:beaconid], f_value)
                Record.create(:user_id => from_user_id, :beaconid=>beaconid, :game_id => params[:game_id], :score => @rp, :object_type=>'Redpack', :object_id => rp.id)            
              end
            else
              f_value = 0
            end
          end
          Score.create(:user_id =>current_user.id, :from_user_id =>from_user_id, :beaconid=>beaconid, :game_id => params[:game_id], :value => f_value)
        end
      end
      render :status => 200, json: {'value' => f_value }
    else
      render :status => 200, json: {'result' => 'not current_user or score' }
    end
  end


  def report
    if current_user
      Record.create(:user_id => current_user.id, :beaconid=>@beacon.id, :game_id => params[:game_id], :sn=>params[:sn], :score => params[:score], :remark=>params[:remark])
    end
    render nothing: true
  end
  
  
  def uv
    if current_user
      Uv.create(:user_id => current_user.id, :beaconid=>@beacon.id, :game_id => params[:game_id], :remark=>params[:remark])
    end
    render nothing: true
  end


  def score
    if current_user
      Score.create(:user_id => current_user.id, :beaconid=>@beacon.id, :value => params[:score], :remark=>params[:remark])
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
      key = "score_#{cid}_top"
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

  def broadcast
    response.headers['Content-Type'] = 'text/event-stream'
    msgs = []
    if @beacon.get_message
      msgs << {:content => @beacon.get_message.content, :type =>'text'}
    end 
    @beacon.records.where('score > 0').order('created_at desc').limit(3).sample(1).each do |r|
      msgs << {:content => r.to_s, :type => 'text'}
    end
    msg = msgs.sample(1)[0]

    return unless @object
    @amount = TimeAmount.get_amount(@object.id,params[:beaconid])
    fake_amount = @amount + 100000

    msg = msg.merge(:amount => fake_amount/100)
    msg_count = current_user.msg_count(@beacon.id)
    checked = current_user.checked?(@material.id, @beacon.id)? 1:0
    msg = msg.merge({:amount => fake_amount/100, :msg_count => msg_count, :checked => checked})
    response.stream.write "data: #{msg.to_json} \n\n"
    sleep 1
    response.stream.close
  end


  private

  def pre
   get_material
   get_beacon
   get_object
 end


 def authorize_url(url)
  appid = "wx456ffb04ee140d84"
  if params[:beaconid]
    get_beacon
    appid = @beacon.get_merchant.wxappid
  end
  "http://#{WX_DOMAIN}/#{appid}/launch?rurl=" + url
  
  #rurl = "http://#{WX_DOMAIN}/users/auth/weixin/callback?rurl=" + url
  #scope = 'snsapi_userinfo'
  #"https://open.weixin.qq.com/connect/oauth2/authorize?appid=#{WX_APPID}&redirect_uri=#{rurl}&response_type=code&scope=#{scope}&connect_redirect=1#wechat_redirect"
end

def check_cookie
  if true
    unless current_user
      if cookies.signed[:remember_me].present?
        user = User.find_by_rememberme_token cookies.signed[:remember_me]
        if user && user.rememberme_token == cookies.signed[:remember_me]
          session[:admin_user_id] = user.id
          current_user = user
          User.current_user = current_user
        end
      end
    end
  end
end

def check_shake_history
  if params[:ticket] and params[:activityid]
    ShakeRecord.create(:ticket=>params[:ticket], :activityid=>params[:activityid], :request_url =>request.url )
  end
end


def weixin_authorize
  #check_cookie
  check_shake_history
  unless current_user
    redirect_to authorize_url(request.url)
  end
end

def get_material  
  @material = Material.by_hook params[:id] if params[:id]
  @material = Material.by_hook params[:game_id] if params[:game_id]
end

def get_beacon
  @beacon = Ibeacon.find_by_url params[:beaconid] if params[:beaconid]
  @beacon = Ibeacon.find(1) unless @beacon
end

def get_object
  if @material
    if not @material.object_type.blank? and @material.object_id
      @object = @material.object_type.capitalize.constantize.find @material.object_id
    end
    @record = current_user.get_record(@beacon.id, @material.id) if current_user
    get_time_amount if @object.instance_of?(Redpack)
  end
end

def get_time_amount
  @check_today = Check.check_today(current_user.id)
  @check_three = Check.check_three(current_user.id, @material.id)
  @amount = TimeAmount.get_amount(@object.id,params[:beaconid])
  @time_amount = TimeAmount.get_time(@object.id)
  return unless @time_amount
  @end_time = @time_amount.time
  @now_time = Time.now
  @fake_amount = (@amount + 100000)/100  
  beaconid = @beacon.id
  Redpack.distribute_seed_redpack(beaconid,@object.id,@material.id)
end
end
