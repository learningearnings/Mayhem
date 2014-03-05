class AddIndexToMessages < ActiveRecord::Migration
  def change
    add_index :messages, [:to_id, :status]
  end
end
