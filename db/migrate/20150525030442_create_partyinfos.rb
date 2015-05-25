class CreatePartyinfos < ActiveRecord::Migration
  def change
    create_table :partyinfos do |t|
      t.string :logo
      t.string :name
      t.string :intro
      t.integer :party_id

      t.timestamps
    end
  end
end
