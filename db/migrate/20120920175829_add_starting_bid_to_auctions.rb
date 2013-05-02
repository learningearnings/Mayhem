class AddStartingBidToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :starting_bid, :decimal, precision: 10, scale: 2
  end
end
