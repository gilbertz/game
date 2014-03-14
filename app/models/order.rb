class Order < Buy

  STATUS = {
      :waiting    => 11,
      :pending    => 22,
      :confirmed  => 33,
      :delivered  => 44,
      :completed  => 55,
      :canceled   => 66,
      :expired    => 77,
      :removed    => 88
  }
  STATU = STATUS

  #声明关联
  has_many   :line_items, dependent: :delete_all
  has_many   :logs, class_name: "OrderLog", dependent: :delete_all
  belongs_to :user
  belongs_to :variant
  belongs_to :shipping_method
  has_one    :payment, autosave: true, dependent: :destroy
  has_one    :bill_address, dependent: :destroy, validate: true
  has_one    :shipment, dependent: :destroy, validate: true

  #验证前回调
  before_validation :generate_order_number, :set_state,  on: :create

  #验证
  validates :meta_address, :line_items, presence: true, on: :create
  validates :user, presence: true
  validate  :check_coinpay,    on: :create
  validate  :check_state,      on: :update

  #回调
  before_create  :link_ty_mobile, :set_price, :reduce_coin_for_user, :set_address
  before_update  :update_usercoin, :update_inventory, if: Proc.new {|o| o.state.in? [66, 77] }
  before_update  :set_effected_at, if: Proc.new {|order| order.state.in? [55, 66,77,88]}
  after_find     :expire_same,     if: Proc.new {|order| order.state == STATUS[:waiting] }

  #scope
  scope :sort_time, -> { order('id desc') }
  scope :waiting,   -> { where(state: STATUS[:waiting]).sort_time }
  scope :paid,      -> { where(state: [22,33,44,55]).sort_time }
  scope :pending,   -> { where(state: STATUS[:pending]).sort_time }
  scope :confirmed, -> { where(state: STATUS[:confirmed]).sort_time }
  scope :delivered, -> { where(state: STATUS[:delivered]).sort_time }
  scope :completed, -> { where(state: STATUS[:completed]).sort_time }
  scope :canceled,  -> { where(state: STATUS[:canceled]).sort_time }
  scope :expired,   -> { where(state: STATUS[:expired]).sort_time }
  scope :removed,   -> { where(state: STATUS[:removed]).sort_time }

  attr_accessor :intermediate, :meta_address#, :virtual_shipment

  def confirm(operator=nil)
    self.logs.build(action: "您的订单已确认", operator: operator)
    self.update_attributes(intermediate: STATUS[:confirmed])
  end

  def delivery(operator=nil)
    self.logs.build(action: "您的订单已发货", operator: operator)
    self.update_attributes(intermediate: STATUS[:delivered])
  end

  def complete(operator=nil)
    self.logs.build(action: "您的订单已完成", operator: operator || '完成')
    self.update_attributes(intermediate: STATUS[:completed])
  end

  def expire
    self.logs.build(action: "您的订单已过期, 失效", operator: '系统')
    self.update_attributes(intermediate: STATUS[:expired])
  end

  def pend
    self.logs.build(action: "您的订单已付款, 请等待系统确认", operator: '客户')
    self.update_attributes(intermediate: STATUS[:pending])
  end

  def cancel(operator=nil)
    self.logs.build(action: "您的订单已付款, 请等待系统确认", operator: operator || '客户')
    self.update_attributes(intermediate: STATUS[:canceled])
  end

  def remove(operator)
    self.logs.build(action: "该订单被删除", operator: operator)
    self.update_attributes(intermediate: STATUS[:removed])
  end

  def valid_payment
    lastpay = self.payment#s.last
                          #if lastpay.state.in?([nil,0,1])
                          #payments.last
                          #elsif lastpay.state == 4
                          #self.payments.create lastpay.attributes.extract!("payment_method_id")
                          #end
  end

  def generate_order_number
    return unless new_record?
    random = "R#{Array.new(9){rand(9)}.join}"
    record = self.class.where(number: random).first
    self.number = random if self.number.blank?
    self.number
  end

  def invert_status; STATU.invert[state] end
  def cn_status; self.cn_status_word[invert_status] end

  def cn_status_word
    arg = {
        waiting:        "未付款",
        pending:        "待处理",
        confirmed:      "已确认",
        delivered:      "已发货",
        completed:      "完成",
        canceled:       "取消",
        expired:        "过期",
        removed:        "删除"
    }
  end

  ##############################################################################
  private
  def link_ty_mobile
    self.mobile = self_user.mobile if self_user
  end

  def set_state
    self.state = STATU[:waiting]
  end

  def set_price
    self.item_total = line_items.to_a.sum {|item| item.price*item.quantity }
    self.shipment_total = shipment.price
    self.total = item_total + shipment_total
    self.payment_total = item_total + shipment_total - coinpay/$coin_exchange_rate
    if self.payment_total == 0
      self.state = STATUS[:pending]
      self.payment.state = 3
    end
  end

  def set_address
    return false if meta_address.class.name != "ShipAddress"
    self.build_bill_address meta_address.try(:copy_attributes)
    meta_address.cart.update_attribute(:last_address, meta_address)
  end

  def update_inventory
    items = self.line_items
    items.each do |item|
      val = item.quantity + item.variant.count_on_hand
      item.variant.update_column(:count_on_hand, val)
      val = item.quantity + item.product.stock
      item.product.update_column(:stock, val)
    end
  end

  def update_usercoin
    return if self.coinpay <= 0
    self_coin.logs.build(user: self_user, income: coinpay, remark: "用于订单(#{self.number})失效", operator: '系统')
    self_coin.increment!(:value, self.coinpay)
  end

  def check_state
    return if intermediate.nil?
    if intermediate == STATUS[:delivered] && state != STATUS[:confirmed]
      errors.add(:state, "notdelivered")
    end
    if intermediate == STATUS[:confirmed] && state != STATUS[:pending]
      errors.add(:state, "notconfirmed")
    end
    if intermediate == STATUS[:pending] && state != STATUS[:waiting]
      errors.add(:state, "nopending")
    end
    if intermediate == STATUS[:canceled] && state != STATUS[:waiting]
      errors.add(:state, "notcancaled")
    end
    if intermediate == STATUS[:waiting]
      errors.add(:state, "notwaiting")
    end
    if intermediate == STATUS[:expired] && state != STATUS[:waiting]
      errors.add(:state, "notexpired")
    end
    if intermediate == STATUS[:completed] && state != STATUS[:delivered]
      errors.add(:state, "ontcompleted")
    end
    if intermediate == STATUS[:removed] && state.in?([11, 22, 33, 44])
      errors.add(:state, "notremoved")
    end
    self.state = intermediate
  end

  def set_effected_at
    self.effected_at = Time.now
  end

  def expire_same
    self.expire if created_at <= 23.hours.ago
  end

  def check_coinpay
    errors.add(:coinpay, :invalid) if self.coinpay% $coin_exchange_rate != 0
    errors.add(:coinpay, :invalid) if self_coin.value < coinpay
  end

  def reduce_coin_for_user
    return if coinpay <= 0
    self_coin.logs.build(user: self_user, expend: coinpay, remark: "用于订单(#{self.number})支付", operator: '客户')
    self_coin.decrement!(:value, self.coinpay)
  end

  def self_coin
    @coin ||= self_user.coin
  end

  def self_user
    @user ||= self.user
  end
end
