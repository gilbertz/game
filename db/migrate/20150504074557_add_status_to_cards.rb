class AddStatusToCards < ActiveRecord::Migration
  def change

    change_column :cards,:state,:integer

    add_column :cards, :status, :string

  end
end
