class UnifyAddresses < ActiveRecord::Migration
  def change
    drop_table :school_addresses
    remove_column :schools, :school_address_id
    remove_column :addresses, :state
    add_column :addresses, :state_id, :integer
  end
end
