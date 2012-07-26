class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :message_body_id
      t.integer :person_id

      t.timestamps
    end
  end
end
