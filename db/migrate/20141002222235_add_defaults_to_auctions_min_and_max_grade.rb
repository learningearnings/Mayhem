class AddDefaultsToAuctionsMinAndMaxGrade < ActiveRecord::Migration
  def change
    change_column :auctions, :min_grade, :integer, default: 0
    change_column :auctions, :max_grade, :integer, default: 12
    
    # Postgres doesn't update old records on changes, so we need to do that manually
    Auction.active.each do |auction|
      auction.min_grade ||= 0
      auction.max_grade ||= 12
      auction.save
    end
  end
end
