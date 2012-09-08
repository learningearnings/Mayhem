class CreateLockerStickerLinks < ActiveRecord::Migration
  def change
    create_table :locker_sticker_links do |t|
      t.integer :locker_id
      t.integer :sticker_id
      t.integer :x
      t.integer :y
      t.timestamps
    end
  end
end
