class CreateHeadlines < ActiveRecord::Migration
  def change
    create_table :headlines do |t|
      t.text :content
      t.string :teacher

      t.timestamps
    end
  end
end
