class AddAuctions < ActiveRecord::Migration
  def change
    create_table :auctions do |t|
      t.datetime :start_date
      t.datetime :end_date
      t.decimal  :current_bid, precision: 10, scale: 2
      t.integer  :product_id
      t.string   :auction_type
      t.timestamps
    end
  end
end
