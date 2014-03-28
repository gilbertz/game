class Ad < ActiveRecord::Base
    def get_show
        key = "ad_show_#{self.id}"
        $redis.get(key)
    end
    
    def get_click
        key = "ad_click_#{self.id}"
        $redis.get(key)
    end
  
end
