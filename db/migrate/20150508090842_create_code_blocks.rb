class CreateCodeBlocks < ActiveRecord::Migration
  def change
    create_table :code_blocks do |t|
      t.integer :category_id
      t.text :code
      t.integer :state

      t.timestamps
    end
  end
end
