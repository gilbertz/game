class TimeAmount < ActiveRecord::Base
    def self.get_amount(redpack_id,beaconid)
        redpack_time = RedpackTime.get_redpack_time(redpack_id)
        return unless redpack_time
        beaconid = Ibeacon.find_by(:url=>beaconid).id
        time_amount = TimeAmount.where("time >= ? and redpack_time_id = ?", Time.now, redpack_time.id).order("time asc")[0]
        amount = Check.where("state = ? and beaconid = ? and created_at <= ? and created_at >= ?", 1 , beaconid, Time.now,(Time.now - 24*3600)).length
        amount = amount*100
        amount = redpack_time.amount if amount > redpack_time.amount
        if time_amount
          time_amount.update(amount: amount)
          return amount
        else
          return 0
        end
    end

    def self.get_time_amount(redpack_id)
        redpack_time = RedpackTime.get_redpack_time(redpack_id)
        return unless redpack_time
        time_amount = TimeAmount.where("time >= ? and redpack_time_id = ?", Time.now, redpack_time.id).order("time asc")[0]
    end

    def self.get_time(redpack_id)
        redpack_time = RedpackTime.get_redpack_time(redpack_id)
        return unless redpack_time
        time = 
    end
end
