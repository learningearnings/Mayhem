# This migration comes from spree_multi_domain (originally 20100227175140)
class AddDefaultStore < ActiveRecord::Migration
  def self.up
    add_column :stores, :default, :boolean, :default => false
  end

  def self.down
    remove_column :stores, :default
  end
end
