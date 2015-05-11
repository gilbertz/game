class TimeAmount < ActiveRecord::Base
    def self.get_amount(redpack_time,beaconid)
        return unless redpack_time
        time_amount = TimeAmount.where("time >= ? and redpack_time_id = ?", Time.now, redpack_time.id).order("time asc")[0]
        amount = Check.where("state = ? and beaconid = ? and created_at <= ? and created_at >= ?", 1 , beaconid, Time.now,(Time.now - 24*3600)).length
        amount = amount*100
        amount = redpack_time.amount if amount > redpack_time.amount
        time_amount.update(amount: amount)
        return amount
    end

    def self.get_time_amount(redpack_time)
        time_amount = TimeAmount.where("time >= ? and redpack_time_id = ?", Time.now, redpack_time.id).order("time asc")[0]
    end
end
