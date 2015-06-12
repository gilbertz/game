class Party < ActiveRecord::Base
  has_one :vip
  has_many :orders
  has_many :managers
  has_one :partyinfo
  has_many :ibeacons
  has_one :fund_account
  has_many :cards
  has_many :materials

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
