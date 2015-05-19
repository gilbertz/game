class Merchant < ActiveRecord::Base
  belongs_to :user

  def self.get_merchants_for_select
    cond = '1=1'
    ms = Merchant.where(cond).limit(50)
    ms.map{|b|[b.name, b.id]}
  end
  
  def beacon_name
    if self.beaconid
      b = Ibeacon.find_by_id self.beaconid
      if b
        return b.name
      end
    end
  end

  def user_name
    self.user.name
  end


  

end
