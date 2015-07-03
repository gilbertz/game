class AddSomeForBuildNew < ActiveRecord::Migration
  def change
    add_column :components, :url, :string
    add_index :appearances, :party_id
    add_index :appearances, [:party_id, :id]
    add_index :activity_components, [:activity_id, :component_id,:status],:name => "index_ac_id_and_status"
  end
end
