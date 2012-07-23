class CreateAvatars < ActiveRecord::Migration
  def change
    create_table :avatars do |t|
      t.string :image_uid
      t.string :image_name
      t.string :image
      t.string :description

      t.timestamps
    end
  end
end
