class AddTypeToPeople < ActiveRecord::Migration
  def change
    add_column :people, :type, :string
    add_index :people, :type
  end
end
