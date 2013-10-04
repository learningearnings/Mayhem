class AddFulfilledToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :fulfilled, :boolean, :default => false
  end
end
