class RemoveParentTokenFromPerson < ActiveRecord::Migration
  def up
  	remove_column :people, :parent_token
  end

  def down
    add_column :people, :parent_token, :string
  end
end
