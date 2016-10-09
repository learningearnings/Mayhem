class RemoveRelationFromPerson < ActiveRecord::Migration
  def up
    remove_column :people, :relationship
    remove_column :people, :phone
  end
  def down
    add_column :people, :relationship, :string
    add_column :people, :phone, :string
  end
end
