class AddApiUserBooleanToSpreeUsers < ActiveRecord::Migration
  def change
    add_column :spree_users, :api_user, :boolean
  end
end
