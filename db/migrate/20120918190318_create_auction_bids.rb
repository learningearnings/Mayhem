class CreateAuctionBids < ActiveRecord::Migration
  def change
    create_table :auction_bids do |t|
      t.integer :person_id
      t.integer :auction_id
      t.decimal :amount, precision: 10, scale: 2
      t.string  :status
      t.timestamps
    end
  end
end
