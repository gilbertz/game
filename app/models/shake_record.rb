class ShakeRecord < ActiveRecord::Base
  belongs_to :ibeacon

  def self.is_shaked(ticket)
    ShakeRecord.find_by(:ticket => ticket)
  end

end
