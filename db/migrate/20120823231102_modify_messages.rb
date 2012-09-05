class ModifyMessages < ActiveRecord::Migration
  def change
    remove_column :messages, :message_body_id
    rename_column :messages, :person_id, :from_id
    add_column :messages, :to_id, :integer
    add_column :messages, :subject, :string
    add_column :messages, :body, :text
  end
end
