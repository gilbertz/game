class AddPartyIdToCards < ActiveRecord::Migration
  def change
    add_column :cards, :deleted_at, :datetime
    add_column :cards, :party_id, :integer
  end
end
