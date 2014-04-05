class Category < ActiveRecord::Base
  has_many :images, as: :viewable, class_name: "Image"
  has_many :materials, class_name: "Material" 

  belongs_to :game_type

  before_destroy :check_its_materials
  def pv
    key = "stat_pv_#{self.id}"
    $redis.get(key)
  end

  def share_count(type)
    key = "wx_cshare_#{type}_#{self.id}"
    $redis.get(key)
  end


  def current_game
    self.materials.last
  end

  def current_game_name                                                                
     last_game = self.materials.last
     if last_game
       last_game.name
     else
       "" 
     end   
  end

  private 
  def check_its_materials
    false if self.materials.length > 0
  end
end
