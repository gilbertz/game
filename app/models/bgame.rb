class Bgame < ActiveRecord::Base
  belongs_to :material

  def cn_state; { 0 => '下线', 1 => '上线', nil => '下线' }[state] end

  def title
    game_name
  end 

  def beacon_name
    if self.beaconid
      b = Ibeacon.find self.beaconid
      return b.name if b
    end
  end

  def get_game
    if self.game_id
      Material.find self.game_id
    end
  end

  def game_name
    if self.game_id
      b = Material.find self.game_id
      return b.name if b
    end
  end
end
