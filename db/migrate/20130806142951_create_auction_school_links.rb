class CreateAuctionSchoolLinks < ActiveRecord::Migration
  def up
    create_table :auction_school_links do |t|
      t.integer :auction_id
      t.integer :school_id

      t.timestamps
    end
  end

  def down
    drop_table :auction_school_links
  end
end
