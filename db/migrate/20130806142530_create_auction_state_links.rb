class CreateAuctionStateLinks < ActiveRecord::Migration
  def up
    create_table :auction_state_links do |t|
      t.integer :auction_id
      t.integer :state_id
      t.timestamps
    end
  end

  def down
    drop_table :auction_state_links
  end
end
