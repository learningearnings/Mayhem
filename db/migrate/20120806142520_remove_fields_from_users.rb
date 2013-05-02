class RemoveFieldsFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :first_name
    remove_column :users, :last_name
    remove_column :users, :dob
    remove_column :users, :grade
  end
end
