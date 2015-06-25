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
      if rp
        money = material.team_reward / material.team_persons
        arr = teamwork.partners
        for uid in 0...arr.count
          rp.send_pay(uid,beacon.id,money)
        end
      end
    end
  end
end