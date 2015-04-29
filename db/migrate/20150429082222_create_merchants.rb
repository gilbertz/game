class CreateMerchants < ActiveRecord::Migration
  def change
    create_table :merchants do |t|
      t.integer :mch_id
      t.string :wxappid
      t.string :key
      t.string :certificate
      t.string :rsa
      t.string :rsa_key

      t.timestamps
    end
  end
end
