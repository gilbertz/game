class ShakeRecord < ActiveRecord::Base
  def self.is_shaked(ticket)
    ShakeRecord.find_by(:ticket => ticket)
  end

end
