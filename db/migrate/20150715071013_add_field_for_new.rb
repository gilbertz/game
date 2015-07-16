class AddFieldForNew < ActiveRecord::Migration
  def change
    add_column :banners, :activity_id, :integer
    add_index :banners, [:activity_id, :state]


    add_column :activities, :uuid, :string
    add_column :components, :uuid, :string


    add_index :activities, :uuid
    add_index :components, :uuid

  end
end
