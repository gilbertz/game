class Domain < ActiveRecord::Base
  def pv
    k = "domain_#{self.id}"
    $redis.get(k)
  end

  def get_name
    tags = ['orange', 'banana', 'apple', 'cherry', 'pear']
    tag = tags.sample(1)[0]
    self.name.gsub("*", "t"+rand(10000).to_s + ".#{tag}"  )
  end
end
