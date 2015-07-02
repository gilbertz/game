class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.integer :party_id
      t.integer :appearance_id
      t.integer :activity_template_id
      t.string :url

      t.timestamps
    end
  end
end
