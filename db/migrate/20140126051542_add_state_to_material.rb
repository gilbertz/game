class AddStateToMaterial < ActiveRecord::Migration
  def change
    add_column :materials, :state, :integer, default: 0, after: :id
    add_column :materials, :description, :text, after: :state
    add_index :materials, [:state]
  end
end
