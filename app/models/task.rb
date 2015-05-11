class Task < ActiveRecord::Base

  validates :name,
            :presence     => true



  def task_des
    para = self.param_format
    para_des = ""
    if self.task_type == REDPACK

    elsif self.task_des == REDPACK_BEGIN_NOTICE

    end
    # self.time_format = 0 0 27-31 * *
    # self.service_name = redpack:generate_redpack

    # redpack_time = RedpackTime.get_redpack_time(5) 
    # min = redpack_time.min
    # max = redpack_time.max
    # beaconid = Ibeacon.find_by(:url=> 'dgbs').id
    # amount = TimeAmount.get_amount(redpack_time,beaconid)
    # total = amount
    # count = amount/200

    # para_des = [total,count,max,min]

    des = "\nevery '#{self.time_format}' do
          rake \"#{self.service_name}#{para_des}\""

  end


  def write_to_crontab
    file_path = "#{Rails.root}/config/schedule.rb"
    file = File.open(filePath,"a+")
    if file
      file.syswrite(task_des)

      `cd #{Rails.root}`
      `whenever -w`
    end

  end




end
