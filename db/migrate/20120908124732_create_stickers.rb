class CreateStickers < ActiveRecord::Migration
  def change
    create_table :stickers do |t|
      t.string :image_uid
      t.timestamps
    end
  end
end
