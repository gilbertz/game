class Domain < ActiveRecord::Base
  def pv
    k = "domain_#{self.id}"
    $redis.get(k)
  end

  def get_name
    self.name.gsub("*", "t"+rand(10000).to_s + ".weixin"  )
  end
end
