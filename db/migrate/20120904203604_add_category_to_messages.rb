class AddCategoryToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :category, :string
    add_index :messages, :category
  end
end
