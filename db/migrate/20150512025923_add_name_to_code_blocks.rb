class AddNameToCodeBlocks < ActiveRecord::Migration
  def change
    add_column :code_blocks, :name, :string
  end
end
