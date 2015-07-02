class CreateActivityTemplates < ActiveRecord::Migration
  def change
    create_table :activity_templates do |t|
      t.string :route_url
      t.integer :attype

      t.timestamps
    end
  end
end
