class AddColumns < ActiveRecord::Migration
  def change
    add_column :materials, :wx_ln, :string, after: :wxdesc
    add_column :materials, :advertisement, :text, after: :wxdesc
    add_column :categories, :wx_js, :text, after: :id
  end
end
