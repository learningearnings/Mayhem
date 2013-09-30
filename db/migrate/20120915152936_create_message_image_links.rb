class CreateMessageImageLinks < ActiveRecord::Migration
  def change
    create_table :message_image_links do |t|
      t.integer :message_id
      t.integer :message_image_id

      t.timestamps
    end
 end
end
