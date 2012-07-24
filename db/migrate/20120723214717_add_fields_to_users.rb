class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :username, :string
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :dob, :datetime
    add_column :users, :grade, :string
    add_column :users, :school_id, :integer
  end
end
