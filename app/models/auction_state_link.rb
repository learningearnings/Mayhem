class AuctionStateLink < ActiveRecord::Base
  belongs_to :state
  belongs_to :auction
  
  attr_accessible :state_id, :auction_id
end
