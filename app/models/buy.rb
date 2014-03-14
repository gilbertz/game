class Buy < ActiveRecord::Base
  self.abstract_class = true
  establish_connection :flash_buy
end