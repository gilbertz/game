class CreateComponentTemplates < ActiveRecord::Migration
  def change
    create_table :component_templates do |t|
      t.string :route_url
      t.integer :cttype

      t.timestamps
    end
  end
end
