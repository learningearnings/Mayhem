class AddTokenToUser < ActiveRecord::Migration
  def change
    add_column :spree_users, :parent_token, :string, :limit => 40
  end
end
