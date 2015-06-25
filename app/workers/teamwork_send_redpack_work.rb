require File.expand_path('../base_worker',__FILE__)

class TeamworkSendRedpackWork < BaseWorker

  def perform(teamwork)
    return unless teamwork
    return if teamwork.is_successful? == false
    #发钱
    material = teamwork.material
    money = material.team_reward / material.team_persons
    arr = teamwork.partner_users
    for i in 0...arr.count


    end

  end

end