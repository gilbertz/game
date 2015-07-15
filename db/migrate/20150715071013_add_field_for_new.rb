class AddFieldForNew < ActiveRecord::Migration
  def change
    add_column :banners, :component_id, :integer
    add_index :banners, [:component_id, :state]


    add_column :activities, :uuid, :string
    add_column :components, :uuid, :string


    add_index :activities, :uuid
    add_index :components, :uuid

  end
end
