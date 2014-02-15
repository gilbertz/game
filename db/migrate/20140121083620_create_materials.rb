class CreateMaterials < ActiveRecord::Migration
  def change
    create_table :materials do |t|
      t.integer  :state, default: 0
      t.text     :description
      t.integer  :category_id
      t.text     :html
      t.string   :name
      t.string   :slug
      t.string   :wx_appid
      t.string   :wx_tlimg
      t.string   :wx_url
      t.string   :wx_title
      t.string   :wxdesc

      t.timestamps
    end
    add_index :materials, [:category_id]
  end
end
