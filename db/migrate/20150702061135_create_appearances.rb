class CreateAppearances < ActiveRecord::Migration
  def change
    create_table :appearances do |t|
      t.string :title
      t.string :logo
      t.string :theme
      t.integer :party_id

      t.timestamps
    end
  end
end
