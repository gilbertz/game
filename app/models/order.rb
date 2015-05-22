class Order < ActiveRecord::Base
  belongs_to :party

  def is_successful?
    self.status == "SUCCESS"
  end

  def set_successful
    self.status = "SUCCESS"
  end

  def set_failure
    self.status = "FAILURE"
  end

  def set_wait_pay
    self.status = "WAITPAY"
  end


end
