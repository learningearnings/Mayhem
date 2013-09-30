class CreateSchoolAddresses < ActiveRecord::Migration
  def change
    create_table :school_addresses do |t|
      t.string :address1
      t.string :address2
      t.string :city
      t.integer :state_id
      t.string :zip

      t.timestamps
    end
  end
end
