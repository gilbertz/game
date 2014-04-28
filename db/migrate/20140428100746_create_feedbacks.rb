class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.string :username
      t.text :content
      t.integer :state, :null => false, :default => 0
      t.timestamps
    end
  end
end
