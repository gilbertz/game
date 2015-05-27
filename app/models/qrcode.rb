class Qrcode < ActiveRecord::Base
  belongs_to :wx_authorizer

  belongs_to :card_record

end
