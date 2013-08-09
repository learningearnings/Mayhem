class CreateAuctionZipCodes < ActiveRecord::Migration
  def change
    create_table :auction_zip_codes do |t|
      t.integer :auction_id
      t.string  :zip_code

      t.timestamps
    end
  end
end
