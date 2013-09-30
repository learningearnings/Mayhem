class RemoveUniqueEmailIndexFromUsers < ActiveRecord::Migration
  def up
    remove_index "spree_users", :name => "email_idx_unique"
  end

  def down
    add_index "spree_users", :name => "email_idx_unique"
  end
end
