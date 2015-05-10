
require File.expand_path('../../../config/initializers/redis',__FILE__)

namespace :redpack do

  desc "生成红包"
  task :generate_redpack,[:naem] do |t,args|

     puts 'generate_redpack'

  end


  desc "通知抢红包"
  task :notice_redpack_begin do

    puts 'notice_redpack_begin'

  end

end