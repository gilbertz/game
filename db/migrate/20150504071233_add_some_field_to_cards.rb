class AddSomeFieldToCards < ActiveRecord::Migration
  def change
    change_column :cards,:state,:string

    add_column :cards, :card_type, :string

    add_column :cards, :code_type,:string

    add_column :cards, :total_quantity,:integer

  end
end
