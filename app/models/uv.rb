class Uv < ActiveRecord::Base

  def uv_key(beacon_id, game_id, day, item)
    return "uv_#{beacon_id}_#{game_id}_#{day}_#{item}"
  end

  def self.per_num(beacon_id,game_id,day)
    item = "per_num"
    unless $redis.exists("uv_#{beacon_id}_#{game_id}_#{day}_#{item}")
      num = Uv.where("created_at >= ? and created_at <= ? and beaconid = ? and game_id = ?",day.beginning_of_day,day.end_of_day,beacon_id,game_id).length
      $redis.set("uv_#{beacon_id}_#{game_id}_#{day}_#{item}",num) 
    end
    return $redis.get("uv_#{beacon_id}_#{game_id}_#{day}_#{item}").to_i
  end

  def self.person_num(beacon_id,game_id,day)
    item = "person_num"
    unless $redis.exists("uv_#{beacon_id}_#{game_id}_#{day}_#{item}")
      num = Uv.where("created_at >= ? and created_at <= ? and beaconid = ? and game_id = ?",day.beginning_of_day,day.end_of_day,beacon_id,game_id).as_json.each{|a| a.select!{|k,v| k =="user_id"}}.uniq.length
      $redis.set("uv_#{beacon_id}_#{game_id}_#{day}_#{item}",num)
    end
    return $redis.get("uv_#{beacon_id}_#{game_id}_#{day}_#{item}").to_i
  end

  def self.new_person_num(beacon_id,game_id,day)
    item = "new_person_num"
    unless $redis.exists("uv_#{beacon_id}_#{game_id}_#{day}_#{item}")
      num = ((Uv.where("created_at >= ? and created_at <= ? and beaconid = ? and game_id = ?",day.beginning_of_day,day.end_of_day,beacon_id,game_id).as_json.each{|a| a.select!{|k,v| k =="user_id"}}.uniq.map{|a|a.to_a}.flatten.delete_if{|a| a=="id"})& (User.new_user_of_day(day))).length 
      $redis.set("uv_#{beacon_id}_#{game_id}_#{day}_#{item}",num)
    end 
    return $redis.get("uv_#{beacon_id}_#{game_id}_#{day}_#{item}").to_i
  end



end
