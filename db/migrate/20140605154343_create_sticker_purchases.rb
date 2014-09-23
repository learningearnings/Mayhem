class CreateStickerPurchases < ActiveRecord::Migration
  def change
    create_table :sticker_purchases do |t|
      t.integer :sticker_id
      t.integer :person_id
      t.datetime :expires_at

      t.timestamps
    end
  end
end
