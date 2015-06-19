class Banner < ActiveRecord::Base

      belongs_to :material

  def state_status
    Admin::BannersController::State[self.state][0]
  end


end