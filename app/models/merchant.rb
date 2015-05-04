class Merchant < ActiveRecord::Base
  belongs_to :user
  
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
