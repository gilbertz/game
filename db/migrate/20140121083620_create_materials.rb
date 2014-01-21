class CreateMaterials < ActiveRecord::Migration
  def change
    create_table :materials do |t|
      t.integer  :category_id
      t.string   :wx_appid
      t.string   :title
      t.string   :slug
      t.text     :content
      t.string   :wx_appid
      t.string   :wx_tlimg
      t.string   :wx_url
      t.string   :wx_title
      t.string   :wx_desc


      t.timestamps
    end
    add_index :materials, [:category_id]
  end
end
