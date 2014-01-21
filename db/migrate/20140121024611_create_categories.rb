class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.integer :parent_id
      t.string  :name
      t.text    :html
      t.text    :meta
      t.text    :js
      t.text    :css
      t.text    :re_css
      t.text    :re_js
      t.text    :re_html

      t.timestamps
    end
  end
end
