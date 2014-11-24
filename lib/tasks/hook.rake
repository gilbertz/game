namespace :hook do

  task :auto => :environment do
    ms = Material.last(100)
    ms.each do |m|
      p m.id, m.pv
      len = Hook.find_all_by_material_id( m.id ).length
      p "hit #{len}"
      if m and m.pv.to_i > 10000 *(len + 1)
        p "auto hook for game #{m.id} #{m.url}", 100000 *(len + 1)
        url = Material.maximum('id').to_s + rand(1000000).to_s
        Hook.create(:material_id => m.id, :url => url) 
        p url
      end
    end     
  end

end
