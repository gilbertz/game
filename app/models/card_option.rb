class CardOption < ActiveRecord::Base
  belongs_to :card

  def get_type
    Card.get_types_for_select[self.group_id.to_i][0]
  end
end
