class Party < ActiveRecord::Base
  has_one :vip
  has_many :orders
  has_many :managers


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


  def party_sign_in




  end


end
