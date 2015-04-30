class Card < ActiveRecord::Base
  has_many :card_options

  def self.get_types_for_select
    [["优惠券", 0], ["折扣券", 1], ["代金券", 2], ["礼品券", 3], ["团购券", 4] ] 
  end

  def beacon_name
    if self.beaconid
      b = Ibeacon.find self.beaconid
      return b.name if b
    end
  end

  def cloning(recursive=false)
    Card.create self.attributes.except!("created_at", "id")
  end 
 
end
