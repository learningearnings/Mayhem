class AuctionZipCode < ActiveRecord::Base
  attr_accessible :zip_code, :auction_id
  belongs_to :auction
  
  attr_accessible :zip_code, :auction_id
end
