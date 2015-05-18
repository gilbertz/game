class CardOption < ActiveRecord::Base
  belongs_to :card

  def get_type
    Card.get_types_for_select[self.group_id.to_i][0]
  end


  def send_redpack(uid, gid, bid)
    if self.group_id == 5
     beacon = Ibeacon.find_by_id(bid)
     rp = beacon.redpacks[0]
     rp_val = rp.weixin_post(user, beacon.url, self.value * 100)
     Record.create(:user_id => uid, :beaconid=>bid, :game_id => gid, :score =>rp_val, :remark=>'现金红包', :object_type=>'Redpack', :object_id => rp.id) 
    end
  end

end
