namespace :convert do

  task :category => :environment do

    Category.where("name like '%转盘%'").update_all(:game_type_id => 2)

  end


end