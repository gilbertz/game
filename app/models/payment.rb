class Payment < Buy

  belongs_to :order

  before_update :update_order_state, if: Proc.new{|p| p.state.eql?(3)}
  before_create :set_out_strade_no_amount_coin_rate

  def cn_state
    case state
      when nil; '未初始化'
      when 1;   '交易开启'
      when 2;   '完成支付'
      when 3;   '交易完成'
    end
  end

  private
  def update_order_state
    self.order.pend && OrderLog.log(order, "支付宝通知：买家完成支付")
  end

  def set_out_strade_no_amount_coin_rate
    $coin_exchange_rate = 100
    num = self.order.number + sprintf("%04d", 1)
    self.out_trade_no = num
    self.coin_rate = $coin_exchange_rate
    self.amount = self.order.payment_total
  end
end
