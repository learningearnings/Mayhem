class AddSalutationToPerson < ActiveRecord::Migration
  def change
    add_column :people, :salutation, :string, :limit => 10
  end
end
