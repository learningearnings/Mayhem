# This migration comes from spree_multi_domain (originally 20110223141800)
class AddEmailToStores < ActiveRecord::Migration
  def self.up    
    change_table :stores do |t|
      t.string :email
    end
  end

  def self.down
    change_table :stores do |t|
      t.remove :email
    end
  end
end
