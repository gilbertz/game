class AddCardInfoToCards < ActiveRecord::Migration
  def change
    add_column :cards, :detail_info, :text
  end
end
