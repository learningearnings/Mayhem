# This migration comes from spree_multi_domain (originally 20091202122944)
class CreateStores < ActiveRecord::Migration
  def self.up
    create_table :stores do |t|
      t.string :name
      t.string :code
      t.text :domains
      t.timestamps
    end
  end

  def self.down
    drop_table :stores
  end
end
