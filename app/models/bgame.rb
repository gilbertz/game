class Bgame < ActiveRecord::Base
  def beacon_name
    if self.beaconid
      b = Ibeacon.find self.beaconid
      return b.name if b
    end
  end

  def game_name
    if self.game_id
      b = Material.find self.game_id
      return b.name if b
    end
  end
end
