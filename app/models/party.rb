require "#{Rails.root}/lib/extend/hash_to_xml"
class Party < ActiveRecord::Base
  has_one :vip
  has_many :orders
  has_many :managers
  has_one :partyinfo
  has_many :ibeacons
  has_one :fund_account
  has_many :cards

  def is_vip?
     self.vip != nil
  end

  # 商户拥有的权限  001是基础权限
  def privileges
    if is_vip?
      vip = self.vip
      vip.privileges == nil ? ["001"] : vip.privileges.split(',')
    else
      ["001"]
    end

  end


  # 商家登录
  def party_sign_in
    authentication = Authentication.find_by_uid(self.openid)
    if authentication
      if authentication.user
        sign_in authentication.user
      end
    end
  end



  def add_balance(balance)
    operate_balance balance
  end

  def subtract_balance(balance)
    balance = -balance
    operate_balance balance
  end

  #企业付款
  def self.qy_pay(user_id,merchant = Merchant.find(1), money=nil,desc = nil)
    # beacon = Ibeacon.find_by_id(beacon_id)
    # return false unless beacon
    return false unless money.to_i > 0
    authentication = Authentication.find_by_user_id(user_id)
    return false unless authentication
    # 防止用户窜发
    m = merchant
    return false if authentication.appid != m.wxappid

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

    body =  generate_qy_pay_param(m,authentication,money,desc)
    # p "body = #{body}"

    request.body = body.to_xml_str
    response = http.start do |http|
      ret = http.request(request)
      puts request.body
      result =  Hash.from_xml(ret.body)
      result = result["xml"]
      result["money"] = money.to_i
      # p result
      if result["return_code"] == "SUCCESS" && result["result_code"] == "SUCCESS"
        result["openid"] = authentication.uid
        Payment.create_from(result)
        return true
      else
        result["openid"] = authentication.uid
        result["mch_appid"] = m.wxappid.to_s
        result["mchid"] = m.mch_id.to_s
        Payment.create_from(result)
        return false
      end
    end

  end

  def self.generate_qy_pay_param(merchant,authentication,money,device_info,desc = '疯狂摇一摇给您送红包了!')
    param_hash = Hash.new
    str = nonce_str
    trade = out_trade_no
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


  def self.time_stamp
    Time.now.to_i.to_s
  end

  def self.nonce_str(len = 16)
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newStr = ""
    1.upto(len) { |i| newStr << chars[rand(chars.size-1)] }
    return newStr
  end

  def self.out_trade_no
    "y1y_" + Time.now.strftime("%Y%m%d-%H%M%S")
  end


  private
  #必须返回boolean值 判断是否加成功
  def operate_balance(balance)
    fund_account = self.fund_account
    if fund_account
      fund_account.balance.add(balance)
      if fund_account.save
        true
      else
        false
      end
    else
      fund_account = FundAccount.create(:balance => balance,:party_id => self.id)
      if fund_account
        true
      else
        false
      end
    end
  end

end
