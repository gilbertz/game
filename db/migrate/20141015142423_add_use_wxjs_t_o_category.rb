class AddUseWxjsTOCategory < ActiveRecord::Migration
  def change
    add_column :categories, :use_wxjs, :boolean
  end
end
