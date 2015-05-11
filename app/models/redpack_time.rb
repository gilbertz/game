class RedpackTime < ActiveRecord::Base
    def self.get_redpack_time(redpack_id)
        redpack_times = RedpackTime.where(:redpack_id =>redpack_id).order("start_time desc")
        if redpack_times and redpack_times.length > 0
           redpack_time = redpack_times[0]
      end
  end
end