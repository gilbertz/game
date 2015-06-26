require File.expand_path('../base_worker',__FILE__)

class TeamworkSendRedpackWork < BaseWorker

  def perform(teamwork_id)
    teamwork = Teamwork.find_by_id(teamwork_id)
    return unless teamwork
    return if teamwork.is_successful? == false
    #发钱
    material = teamwork.material
    bggame = Bgame.where(:state => 1,:game_id=>material.id).first
    if bggame
      beacon = Ibeacon.find_by_id(bggame.beaconid)
      rp = beacon.redpacks[0]
      p rp
      if rp
        money = material.team_reward / material.team_persons
        arr = teamwork.partners
        p arr
        for i in 0...arr.count
          uid = arr[i]
          p "uid = #{uid}"
          ret = rp.send_pay(uid,beacon.id,money)
          if ret && ret.to_i > 0.0
            Record.create(:user_id =>uid, :beaconid=> beacon.id, :game_id => material.id, :score => ret.to_i, :object_type=> 'redpack', :object_id => rp.id,:remark=>material.name)
          end
        end
      end
    end
  end
end