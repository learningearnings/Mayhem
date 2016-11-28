class AddParentTokenToPerson < ActiveRecord::Migration
  def change
    add_column :people, :parent_token, :string
  end
end
