namespace :convert do

  task :category => :environment do
    #Category.where("name like '%转盘%'").update_all(:game_type_id => 2)
  end

  task :sync_redis => :environment do
    Material.find_each do |material|
      redis_pv = material.pv || 0
      redis_wx_share_pyq = material.share_count("pyq") || 0
      material.update_attributes(:redis_pv => redis_pv, :redis_wx_share_pyq => redis_wx_share_pyq)
      puts material.inspect
      puts "----------------------------"
      material.save
    end
  end

end