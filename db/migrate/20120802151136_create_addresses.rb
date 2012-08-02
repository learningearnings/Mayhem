class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.string :line1
      t.string :line2
      t.string :city
      t.string :state
      t.string :zip
      t.string :type
      t.float  :latitude
      t.float  :longitude
      t.references :addressable, :polymorphic => true
      t.timestamps
    end

    add_index :addresses, :addressable_type
    add_index :addresses, :addressable_id
    add_index :addresses, :type
  end

  def self.down
    drop_table :addresses
  end
end
