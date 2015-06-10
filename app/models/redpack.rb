require "#{Rails.root}/lib/extend/hash_to_xml"
class Redpack < ActiveRecord::Base

  require 'net/https'
  require 'uri'
  require 'rexml/document'
  include REXML
  
  belongs_to :ibeacon
  has_many :redpack_time

  def self.get_types_for_select
    [["普通红包", 0], ["德高红包", 1], ["社交红包", 3] ]
  end

  def title
    self.action_title
  end

  def beacon_name
    if self.beaconid
      b = Ibeacon.find self.beaconid
      return b.name if b
    end
  end

  def cloning(recursive=false)
    Redpack.create self.attributes.except!("created_at", "id")
  end


  # pattern == 0 ==> 红包
  # pattern == 非 0 ==> 企业付款
  def send_pay(user_id,beacon_id,money=nil)
    pattern = 0 unless self.pattern
    money = get_redpack_rand(beacon_id) unless money
    if pattern == 0 && money.to_i >= 100
      weixin_post(user_id,beacon_id,money)
    else
      qy_pay(user_id,money)
    end
  end


  def weixin_post(user_id,beacon_id, money=nil)
    beacon = Ibeacon.find_by_id(beacon_id)
    return unless beacon
    m = beacon.get_merchant
    authentication = Authentication.find_by_user_id(user_id)
    return false unless authentication
    # 防止用户窜发
    return false if authentication.appid != m.wxappid

    uri = URI.parse('https://api.mch.weixin.qq.com/mmpaymkttransfers/sendredpack')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if uri.scheme == "https"  # enable SSL/TLS
    http.cert =OpenSSL::X509::Certificate.new(File.read(m.certificate))
    http.key =OpenSSL::PKey::RSA.new(File.read(m.rsa), m.rsa_key)# key and password
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE #这个也很重要

    request = Net::HTTP::Post.new(uri)
    request.content_type = 'text/xml'

    request.body = array_xml(user_id,beacon_id, m, money)
    response = http.start do |http|
      ret = http.request(request)
      puts request.body
      puts ret.body
      doc = Document.new(ret.body)
      chapter1 = doc.root.elements[8] #输出节点中的子节点
      puts chapter1.text #输出第一个节点的包含文本
      return chapter1.text
    end
  end

  def array_xml(user_id,beacon_id, m, money=nil)
    
    current_redpack = self
    money = get_redpack_rand(beacon_id) unless money
    user = User.find_by_id(user_id)
    doc = Document.new"<xml/>"
    root_node = doc.root
    el14 = root_node.add_element "act_name"
    el14.text = current_redpack.action_title
    el13 = root_node.add_element "client_ip"
    el13.text = '121.42.47.121'
    el10 = root_node.add_element "max_value"
    el10.text = money
    el2 = root_node.add_element "mch_billno"
    el2.text = m.mch_id.to_s + Time.new.strftime("%Y%d%m").to_s+rand(9999999999).to_s
    el3 = root_node.add_element "mch_id"
    el3.text = m.mch_id.to_s
    el9 = root_node.add_element "min_value"
    el9.text = money
    el5 = root_node.add_element "nick_name"
    el5.text = "盛也网络公司"
    el21 = root_node.add_element "nonce_str"
    el21.text = Digest::MD5.hexdigest(rand(999999).to_s).to_s
    el22 = root_node.add_element "re_openid"
    el22.text = user.get_openid
    el16 = root_node.add_element "remark"
    el16.text = current_redpack.action_remark
    el6 = root_node.add_element "send_name"
    el6.text = current_redpack.sender_name
    el8 = root_node.add_element "total_amount"
    el8.text = money
    el11 = root_node.add_element "total_num"
    el11.text = 1
    el12 = root_node.add_element "wishing"
    el12.text = current_redpack.wishing
    el4 = root_node.add_element "wxappid"
    el4.text = m.wxappid

    stringA="act_name="+el14.text.to_s+"&client_ip="+el13.text.to_s+"&max_value="+el10.text.to_s+"&mch_billno="+el2.text.to_s+"&mch_id="+el3.text.to_s+"&min_value="+el9.text.to_s+"&nick_name="+el5.text.to_s+"&nonce_str="+el21.text.to_s+"&re_openid="+el22.text.to_s+"&remark="+el16.text.to_s+"&send_name="+el6.text.to_s+"&total_amount="+el8.text.to_s+"&total_num="+el11.text.to_s+"&wishing="+el12.text.to_s+"&wxappid="+el4.text.to_s
    stringSignTemp=stringA+"&key=" + m.key
    puts stringSignTemp
    sign=Digest::MD5.hexdigest(stringSignTemp).upcase
    el1 = root_node.add_element "sign"
    el1.text = sign

    return doc.to_s
  end



  #企业付款
  def qy_pay(user_id, money=nil)
    beacon_id = self.beaconid
    beacon = Ibeacon.find_by_id(beacon_id)
    p beacon.to_json
    return  unless beacon
    authentication = Authentication.find_by_user_id(user_id)
    p authentication.to_json
    return  unless authentication
    # 防止用户窜发
    m = beacon.get_merchant
    # return  if authentication.appid != m.wxappid

    # p "m = #{m.to_json}"
    # p "authentication = #{authentication.to_json}"

    uri = URI.parse('https://api.mch.weixin.qq.com/mmpaymkttransfers/promotion/transfers')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if uri.scheme == "https"  # enable SSL/TLS
    http.cert =OpenSSL::X509::Certificate.new(File.read(m.certificate))
    http.key =OpenSSL::PKey::RSA.new(File.read(m.rsa), m.rsa_key)# key and password
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE #这个也很重要

    request = Net::HTTP::Post.new(uri)
    request.content_type = 'text/xml'

    body =  generate_qy_pay_param(beacon_id,m,authentication,money)
    money = body["amount"]
    # p "body = #{body}"

    request.body = body.to_xml_str
    response = http.start do |http|
      ret = http.request(request)
      puts request.body
      result =  Hash.from_xml(ret.body)
      result = result["xml"]
      result["money"] = money.to_i
      p result
      if result["return_code"] == "SUCCESS" && result["result_code"] == "SUCCESS"
        result["openid"] = authentication.uid
        Payment.create_from(result)
        return money
      else
        result["openid"] = authentication.uid
        result["mch_appid"] = m.wxappid.to_s
        result["mchid"] = m.mch_id.to_s
        Payment.create_from(result)
        return
      end
    end

  end

  def generate_qy_pay_param(beacon_id,merchant,authentication,money)
    param_hash = Hash.new
    str = nonce_str
    trade = out_trade_no
    desc = self.action_title || "疯狂摇一摇给您送红包了!"
    desc += "   #{self.wishing}"
    money = get_redpack_rand(beacon_id) unless money
    param_hash["mch_appid"]= merchant.wxappid.to_s
    param_hash["mchid"] = merchant.mch_id.to_s
    param_hash["partner_trade_no"] = trade
    param_hash["nonce_str"] = str
    param_hash["desc"] = desc
    param_hash["amount"] = money
    param_hash["openid"] = authentication.uid
    param_hash["re_user_name"] = authentication.user_name
    param_hash["check_name"] = "NO_CHECK"
    #本机ip地址
    local_ip = IPSocket.getaddress(Socket.gethostname)
    param_hash["spbill_create_ip"] = local_ip
    stringA = "amount=#{money}&check_name=#{"NO_CHECK"}&desc=#{desc}&mch_appid=#{merchant.wxappid.to_s}&mchid=#{merchant.mch_id.to_s}&nonce_str=#{str}&openid=#{authentication.uid.to_s}&partner_trade_no=#{trade}&re_user_name=#{authentication.user_name}&spbill_create_ip=#{local_ip}"
    stringSignTemp = "#{stringA}&key=#{merchant.key}"
    sign = Digest::MD5.hexdigest(stringSignTemp).upcase
    param_hash["sign"] = sign
    return param_hash
  end


  def time_stamp
    Time.now.to_i.to_s
  end

  def nonce_str(len = 16)
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newStr = ""
    1.upto(len) { |i| newStr << chars[rand(chars.size-1)] }
    return newStr
  end

  def out_trade_no
    "y1y_" + Time.now.strftime("%Y%m%d-%H%M%S")
  end





  def get_current_redpack(beacon_id)
    current_redpack = Redpack.find_by(beaconid: beacon_id)
    return current_redpack
  end

  def get_redpack_rand(beacon_id)
    rand_num = rand(10)
    current_redpack = get_current_redpack(beacon_id)
    min = current_redpack.min*100
    max = current_redpack.max*100
    weight_1 = 0.5
    weight_2 = 0.8
    if (0..4).include?(rand_num)
      redpack_rand = (rand(min..((max-min)*weight_1+min))/100).to_i
    elsif (5..8).include?(rand_num)
      redpack_rand = (rand(((max-min)*weight_1+min)..((max-min)*weight_2+min))/100).to_i
    elsif (9..9).include?(rand_num)
      redpack_rand = (rand(((max-min)*weight_2+min)..max)/100).to_i
    end
    return redpack_rand
  end

  def get_redpack_times
    if self.id
      RedpackTime.where(:redpack_id => self.id)
    else
      []
    end
  end

  def get_redpack_values
    if self.id
      RedpackValue.where(:redpack_id => self.id)
    else
      []
    end
  end

  def get_redpack_people
    if self.id
      RedpackPerson.where(:redpack_id => self.id)
    else
      []
    end
  end

  def self.x_random(min,max)
    return (rand((max-min) ** 2) ** (1.0/2)).to_i
  end

  def self.next_long(min,max)
    return rand(max-min+1) + min
  end

  def self.generate(total,count,max,min, rp_id)
    $redis.del("hongbaolist_#{rp_id}")
    $redis.del("hongBaoConsumedMap_#{rp_id}")
    $redis.del("hongBaoConsumedList_#{rp_id}")

    result = Array.new(count)
    result_hongbao = Array.new(0)
    if total == 0
    elsif  total < min
      min = total
      result[0] = min
      result_hongbao = {:id => 0, :money => result[0]}
      $redis.lpush("hongbaolist_#{rp_id}",result_hongbao.to_json)
      #p $redis.lrange("hongbaolist",0,-1)
      return $redis.lrange("hongbaolist_#{rp_id}",0,-1)
    else
      average = total/count

      a = average - min
      b = max - average

      range1 = (average - min) ** 2
      range2 = (max - average) ** 2

      for i in 0..(result.length-1)
        if (next_long(min,max) > average)
          temp = min + x_random(min,average)
          result[i] = temp
          total -= temp
        else
          temp = max - x_random(average,max)
          result[i] = temp
          total -= temp
        end
      end

      while (total > 0)
        for i in 0..(result.length-1)

          if total > 0 && result[i] < max 
            result[i] += 1
            total -= 1
          end
        end
      end

      while (total < 0)
        for i in 0..(result.length-1)
          if total < 0 && result[i] > min
            result[i] -= 1
            total += 1
          end
        end
      end

      for i in 0..(result.length-1)
        result_hongbao = {:id => i, :money => result[i]}
        $redis.lpush("hongbaolist_#{rp_id}",result_hongbao.to_json)
      end

      # p $redis.lrange("hongbaolist",0,-1)
      # return result
      return $redis.lrange("hongbaolist_#{rp_id}",0,-1)
    end
  end

  def add_redpack_value(redpack_id)
    if  RedpackValue.where(redpack_id: redpack_id)
      
    end

  end
  # def self.ge

  #   generate(500,2.5,600,150)
  # #   $redis.script(try_get_hongbao_script)
  # #    for i in 0..9
  # #   p $redis.eval(tryGetHongBaoScript, 4, "hongBaoList", "hongBaoConsumedList", "hongBaoConsumedMap", i); 
  # # end
  # end

  def self.test(user_id, rp_id)
    if $redis.hexists("hongBaoConsumedMap_#{rp_id}" , user_id) == true 
      p $redis.hget("hongBaoConsumedMap_#{rp_id}",user_id)
      return nil
    else
      hongbao = $redis.rpop("hongbaolist_#{rp_id}")
      if hongbao
        hongbao = JSON.parse(hongbao)
        hongbao.merge!({:user_id => user_id})
        $redis.hset("hongBaoConsumedMap_#{rp_id}",user_id,user_id)
      #p $redis.hget("hongBaoConsumedMap",user_id)
      $redis.lpush("hongBaoConsumedList_#{rp_id}",hongbao.to_json)
      #p $redis.lrange("hongBaoConsumedList",0,-1)
      return hongbao 
    else
      return nil
    end

  end
end

def self.distribute_seed_redpack(beacon_id,redpack_id,game_id)
  if $redis.llen("hongBaoConsumedList_#{redpack_id}") != 0
   for i in 0..($redis.llen("hongBaoConsumedList_#{redpack_id}")-1)
    hongbao = JSON.parse($redis.rpop("hongBaoConsumedList_#{redpack_id}"))
    user_allocaiton = UserAllocation.find_by(:user_id => hongbao["user_id"])
    if user_allocaiton 
      user_allocaiton.update( :allocation => (user_allocaiton.allocation + hongbao["money"]))
    else
      UserAllocation.create(:user_id => hongbao["user_id"], :allocation => hongbao["money"])
    end
    Record.create(:user_id => hongbao["user_id"], :from_user_id => hongbao["user_id"], :beaconid=> beacon_id, :game_id => game_id, :score => hongbao["money"], :object_type=> 'Redpack', :object_id => redpack_id)
  end
end
end

def self.gain_seed_redpack(user_id, game_id,redpack,beaconid) 
    # hongbao =  Hash.new
    # if $redis.llen("hongbaolist") == 0
    #   for i in 0..(llen("hongBaoConsumedMap")-1)
    #     beaconid = Ibeacon.find_by(:url=>beaconid).id
    #     redpack_time = RedpackTime.where(:redpack_id =>redpack.id).order("start_time desc")[0]
    #     person_num = redpack_time.person_num
    #     user_allocaiton = UserAllocation.find_by(:user_id => hongbao["user_id"])
    #     if user_allocaiton 
    #       user_allocaiton.update( :allocation => (user_allocaiton.allocation + hongbao["money"]), :num => (person_num - 1))
    #     else
    #       UserAllocation.create(:user_id => hongbao["user_id"], :allocation => hongbao["money"], :num => (person_num - 1))
    #     end
    #     Score.create(:user_id => hongbao["user_id"], :value => hongbao["money"],:from_user_id => hongbao["user_id"])
    #     Record.create(:user_id => hongbao["user_id"], :from_user_id => hongbao["user_id"], :beaconid=> beaconid, :game_id => game_id, :score => hongbao["money"], :allocation => hongbao["money"])
    #     p "yongwanle"
    #   end 
    # end

    if $redis.hexists("hongBaoConsumedMap_#{redpack.id}" , user_id) == true 
      p $redis.hget("hongBaoConsumedMap_#{redpack.id}",user_id)
      return 0 
    else
      hongbao = $redis.rpop("hongbaolist_#{redpack.id}")
      if hongbao
        hongbao = JSON.parse(hongbao)
      p hongbao
      hongbao.merge!({:user_id => user_id})
       p $redis.lrange("hongbaolist",0,-1)
      $redis.hset("hongBaoConsumedMap_#{redpack.id}",user_id,user_id)
       p $redis.hget("hongBaoConsumedMap",user_id)
      $redis.lpush("hongBaoConsumedList_#{redpack.id}",hongbao.to_json)
       p $redis.lrange("hongBaoConsumedList",0,-1)
      


      user = User.find user_id
      # just for tmp
      beaconid = 6 if beaconid == 20
      user.incr_social(beaconid, 3)
       
      return hongbao["money"]
    else
      return 0
      p "no hongbao"
    end
  end
end
end

