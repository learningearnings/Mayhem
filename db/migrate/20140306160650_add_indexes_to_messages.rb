class AddIndexesToMessages < ActiveRecord::Migration
  def change
    add_index :messages, [:to_id, :category, :status]
    add_index :messages, [:to_id, :status]
  end
end
