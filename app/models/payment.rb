class Payment < ActiveRecord::Base


  def self.create_from(hash)
    return nil unless hash
    payment = Payment.new
    payment.mch_appid = hash["mch_appid"] || hash["wxappid"]
    payment.mchid = hash["mchid"] || hash["mch_id"]
    payment.device_info = hash["device_info"]
    payment.partner_trade_no = hash["partner_trade_no"]
    payment.payment_no = hash["payment_no"] || hash["mch_billno"]
    payment.payment_time = hash["payment_time"] || hash["send_time"]
    payment.return_code = hash["return_code"]
    payment.return_msg = hash["return_msg"].to_s
    payment.result_code = hash["result_code"]
    payment.err_code = hash["err_code"]
    payment.err_code_des = hash["err_code_des"].to_s
    payment.openid = hash["openid"]
    payment.money = hash["money"].to_i
    payment.beaconid = hash["beaconid"]
    payment.pattern = hash["pattern"]
    payment.send_listid = hash["send_listid"]
    if payment.save
      return payment
    end
  end



end
