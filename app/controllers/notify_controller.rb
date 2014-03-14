class NotifyController < ApiController

  def alipay
    notify_params = params.except(*request.path_parameters.keys)
    logger.info "####################################################33"
    logger.info notify_params
    logger.info "print before verify"
    logger.info "print alipay verify"
    @payment = Payment.find_by!(out_trade_no: params[:out_trade_no])
    logger.info "finded payment object at database"
    logger.info params[:trade_status]
    num = case params[:trade_status]
            when 'WAIT_BUYER_PAY'; 1 # 交易开启
            when 'WAIT_SELLER_SEND_GOODS'; 2# 买家完成支付
            when 'TRADE_FINISHED'; 3 # 交易完成
            when 'TRADE_CLOSED'; 4 # 交易被关闭
          end
    if @payment.update_attribute(:state, num)
      logger.info "alipay return sucess message"
      return render(text: 'success')
    end
    logger.info "alipay return error message"
    #end
  end

end