class Redpack < ActiveRecord::Base
  require 'net/https'
  require 'uri'
  require 'rexml/document'
  include REXML

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
 

  def weixin_post(user,beaconid_url)
    uri = URI.parse('https://api.mch.weixin.qq.com/mmpaymkttransfers/sendredpack')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if uri.scheme == "https"  # enable SSL/TLS
    http.cert =OpenSSL::X509::Certificate.new(File.read("weixin_pay/cert/apiclient_cert.pem"))
    http.key =OpenSSL::PKey::RSA.new(File.read("weixin_pay/cert/apiclient_key.pem"), '1229344702')# key and password
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE #这个也很重要

    request = Net::HTTP::Post.new(uri)
    request.content_type = 'text/xml'

    request.body = array_xml(user,beaconid_url)
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

  def array_xml(user,beaconid_url)
    current_redpack = get_current_redpack(beaconid_url)
    money = get_redpack_rand(beaconid_url)
    doc = Document.new"<xml/>"
    root_node = doc.root
    el14 = root_node.add_element "act_name"
    el14.text = current_redpack.action_title
    el13 = root_node.add_element "client_ip"
    el13.text = '121.42.47.121'
    el10 = root_node.add_element "max_value"
    el10.text = money
    el2 = root_node.add_element "mch_billno"
    el2.text = '1233034702'+Time.new.strftime("%Y%d%m").to_s+rand(9999999999).to_s
    el3 = root_node.add_element "mch_id"
    el3.text = '1233034702'
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
    el4.text = WX_APPID

    stringA="act_name="+el14.text.to_s+"&client_ip="+el13.text.to_s+"&max_value="+el10.text.to_s+"&mch_billno="+el2.text.to_s+"&mch_id="+el3.text.to_s+"&min_value="+el9.text.to_s+"&nick_name="+el5.text.to_s+"&nonce_str="+el21.text.to_s+"&re_openid="+el22.text.to_s+"&remark="+el16.text.to_s+"&send_name="+el6.text.to_s+"&total_amount="+el8.text.to_s+"&total_num="+el11.text.to_s+"&wishing="+el12.text.to_s+"&wxappid="+el4.text.to_s
    stringSignTemp=stringA+"&key=wangpeisheng1234567890leapcliffW"
    puts stringSignTemp
    sign=Digest::MD5.hexdigest(stringSignTemp).upcase
    el1 = root_node.add_element "sign"
    el1.text = sign

    return doc.to_s
  end

  def get_current_redpack(beaconid_url)
    beaconid = Ibeacon.find_by(:url=>beaconid_url).id
    current_redpack = Redpack.find_by(beaconid: beaconid)
    return current_redpack
  end

  def get_redpack_rand(beaconid_url)
    rand_num = rand(10)
    current_redpack = get_current_redpack(beaconid_url)
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

  def weixin_post_money(user,beaconid,money)
  end

  def first_allocation(user_id, game_id,redpack) 
    redpack_time = RedpackTime.find_by(:redpack_id =>redpack.id)
    person_num = redpack_time.person_num
    time_amount = TimeAmount.find_by("time_end >? and time < ? and redpack_time_id = ? ", Time.now, Time.now, redpack_time.id)
    if time_amount.amount> 0
      min = redpack_time.min
      max = redpack_time.max
      record_allocation = time_amount > min ? rand(min..max) : min
      record_score = rand((min/person_num)..(record_allocation/person_num))
      time_amount.update(:amount => (time_amount.amount - record_allocation))
      UserAllocation.create(:user_id => user_id, :allocation => (record_allocation -record_score), :num => (person_num - 1))
      Score.create(:user_id => user_id, :value => record_score,:from_user_id => user_id)
      Score.create(:user_id => user_id, :value => -record_score,:from_user_id => user_id)
      Record.create(:user_id => user_id, :from_user_id => user_id, :beaconid=> beaconid, :game_id => game_id, :score => record_score, :allocation => record_allocation)
    end
    
   def share_allocation(user_id, openidshare , game_id, redpack)
     redpack_time = RedpackTime.find_by(:redpack_id =>redpack.id)
     person_num = redpack_time.person_num
     if openidshare
      au = Authentication.find_by_uid(openidshare)
      from_user_id = au.user_id 
      from_user = User.find from_user_id 
      user_allocation= UserAllocation.find_by("user_id = ? and allocation > ? and num > ?", from_user_id , 0, 0)
      if user_allocation == nil 
        render :status => 200, json: {'info' => "已经被抢光啦，发卡券吧"}
      end
      if user_allocation.num > 2
        record_allocation = rand((user_allocation.allocation/person_num/2)..(user_allocation.allocation/person_num*2))   
      elsif user_allocation.num = 1
        record_allocation = user_allocation.allocation
      end  
      record_score = rand((record_allocation/person_num/2)..(record_allocation/person_num*2))
      user_allocation.update(:user_id => from_user_id, :allocation => (user_allocation.allocation - record_allocation), :num => (user_allocation.num - 1))
      UserAllocation.create(:user_id => user_id, :allocation => (record_allocation -record_score)) 
      Score.create(:user_id => user_id, :value => record_score,:from_user_id => from_user_id)
      Record.create(:user_id => user_id, :from_user_id => from_user_id, :beaconid=> beaconid, :game_id => game_id, :score => record_score, :allocation => record_allocation)
    end

    def bus_redpack(user_id, beaconid) 
      score = UserScore.find_by(user_id: user_id).total_score 
      Redpack.find_by(beaconid: beaconid).weixin_post(current_user, beaconid_url, score)
      Score.create(:user_id => current_user.id, :value => -score,:from_user_id => current_user.id)
    end 

  end
