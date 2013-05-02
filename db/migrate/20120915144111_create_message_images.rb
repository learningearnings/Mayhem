class CreateMessageImages < ActiveRecord::Migration
  def change
    create_table :message_images do |t|
      t.string :image_uid

      t.timestamps
    end
  end
end
