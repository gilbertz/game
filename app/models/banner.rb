class Banner < ActiveRecord::Base

      belongs_to :material

  def cn_btype; { 0 => '小banner', 1 => '大banner'}[btype] end

  def state_status
    Admin::BannersController::State[self.state][0]
  end


end