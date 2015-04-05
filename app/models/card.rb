class Card < ActiveRecord::Base
  def beacon_name
    if self.beaconid
      b = Ibeacon.find self.beaconid
      return b.name if b
    end
  end
  
end
