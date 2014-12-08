class Domain < ActiveRecord::Base
  def pv
    k = "domain_#{self.id}"
    $redis.get(k)
  end

  def get_name
    tags = ['weixin', 'ifeng', 'jd', 'apple', 'sogou']
    tag = tags.sample(1)[0]
    
    rlen = 5 + rand(5)
    rtag = ('a'..'z').to_a.shuffle[0..rlen].join 
    self.name.gsub("*", 'new' + rtag )
    #self.name.gsub("*", "mp.weixin.qq.com")
  end
end
