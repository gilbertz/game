class QrcodeController < ApplicationController

  def query_scaner
    @scaner = nil
    ticket = params["ticket"]
    if ticket
      qrcode = Qrcode.find_by_ticket(ticket)

      if qrcode && qrcode.expire_at.to_i < Time.now.to_i
        @scaner = qrcode.scaner
      end
    end

    if @scaner
      redirect_to "http://www.baidu.com"
    end

  end
end
