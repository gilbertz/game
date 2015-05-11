class Task < ActiveRecord::Base

  validates :name,
            :presence     => true



  def task_des
    para = self.param_format
    para_des = ""
    if self.task_type == REDPACK

    elsif self.task_des == REDPACK_BEGIN_NOTICE

    end

    self.time_format = 9,19,29,39,49,59 15,16,17,18,19,20,21,22,23 11,12 5 2015 
    self.service_name = redpack::generate_redpack 
    total = 40000
    count = 200
    max = 600
    min = 150
    para_des = [total,count,max,min]

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
