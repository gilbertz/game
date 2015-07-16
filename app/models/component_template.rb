class ComponentTemplate < ActiveRecord::Base
  has_many :components

  def cn_cttype
    { 0 => '红包', 1 => '卡券', 2 => '游戏',3 => '签到',4 => '转盘',nil => '游戏' }[self.cttype]
  end

end
