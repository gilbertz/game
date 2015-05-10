class Task < ActiveRecord::Base

  validates_presence(:service_name,:message => "任务名不能为空")



  def task_des
    para = self.param_format
    para_des = ""
    if self.task_type == REDPACK

    elsif self.task_des == REDPACK_BEGIN_NOTICE

    end
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
