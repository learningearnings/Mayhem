class AddSchoolIdAndPersonIdToSpreeUsers < ActiveRecord::Migration
  def change
    add_column :spree_users, :school_id, :integer
    add_column :spree_users, :person_id, :integer
    add_column :spree_users, :username, :string
  end
end
