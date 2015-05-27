class CardRecord < ActiveRecord::Base

  has_one :qrcode

  def set_status_used
    self.status = 1
  end


  def is_used
    self.status == 1
  end

end
