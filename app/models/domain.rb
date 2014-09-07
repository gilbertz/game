class Domain < ActiveRecord::Base
  def pv
    k = "domain_#{self.id}"
    $redis.get(k)
  end

  def get_name
    self.name.gsub("*", "game"+rand(100).to_s )
  end
end
