class AddRelationToPerson < ActiveRecord::Migration
  def change
    add_column :people, :relationship, :string
    add_column :people, :phone, :string
  end
end
