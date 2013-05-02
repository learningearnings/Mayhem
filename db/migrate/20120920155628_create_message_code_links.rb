class CreateMessageCodeLinks < ActiveRecord::Migration
  def change
    create_table :message_code_links do |t|
      t.integer :message_id
      t.integer :otu_code_id

      t.timestamps
    end
  end
end
