class CreateQrcodes < ActiveRecord::Migration
  def change
    create_table :qrcodes do |t|
      t.string :wx_authorizer_id
      t.string :action_name
      t.string :scene_id
      t.string :scene_str
      t.string :ticket
      t.string :url
      t.datetime :expire_at

      t.timestamps
    end
  end
end
