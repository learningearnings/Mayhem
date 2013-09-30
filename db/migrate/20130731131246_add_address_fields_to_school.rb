class AddAddressFieldsToSchool < ActiveRecord::Migration
  def change
    add_column :schools, :address1, :string
    add_column :schools, :address2, :string
    add_column :schools, :city, :string
    add_column :schools, :state_id, :integer
    add_column :schools, :zip, :string
  end
end
