namespace :cutlog do
  
  desc "切割日志"
  task :cut => :environment do

    if Rails.env.production?
    origin_log_path = "#{Rails.root}/log/#{Rails.env}.log"
    new_log_path = "#{Rails.root}/log/#{Rails.env}-#{Date.today.to_s}.log"
    `mv  #{origin_log_path}  #{new_log_path}`
    `rm  #{origin_log_path}`
    puts " 切割日志成功!"
    end 
  end

end
