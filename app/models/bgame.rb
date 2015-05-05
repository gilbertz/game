class Bgame < ActiveRecord::Base
  belongs_to :material
  belongs_to :ibeacon

  def cn_state; { 0 => '下线', 1 => '上线', nil => '下线' }[state] end

  def title
    game_name
  end 

  def get_beacon
    if self.beaconid
      Ibeacon.find_by_id self.beaconid
    end
  end

  def beacon_name
    if self.beaconid
      b = Ibeacon.find_by_id self.beaconid
      return b.name if b
    end
  end

  def get_game
    if self.game_id
      Material.find_by_id self.game_id
    end
  end

  def game_name
    if self.game_id
      b = Material.find_by_id self.game_id
      return b.name if b
    end
  end

  def game_link
    self.get_game.get_link(self.get_beacon.url)    
  end

  def get_qr_img
    'http://qr.liantu.com/api.php?text=' + self.game_link
  end

end
