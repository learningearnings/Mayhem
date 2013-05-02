class RemoveSchoolIdFromSpreeUsers < ActiveRecord::Migration
  def up
    remove_column :spree_users, :school_id
  end

  def down
    add_column :spree_users, :school_id
  end
end
