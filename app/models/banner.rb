class Banner < ActiveRecord::Base


  def state_status
    Admin::BannersController::State[self.state][0]
  end


end