class Card < ActiveRecord::Base

  belongs_to :wx_authorizer
  has_many :records


  def beacon_name
    if self.beaconid
      b = Ibeacon.find self.beaconid
      return b.name if b
    end
  end

end
