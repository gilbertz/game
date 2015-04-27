class AddCardIdToCardOptions < ActiveRecord::Migration
  def change
    add_column :card_options, :card_id, :integer
   
    add_index :card_options, [:card_id]
  end
end
