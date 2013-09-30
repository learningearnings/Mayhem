class AuctionStateLink < ActiveRecord::Base
  belongs_to :state
  belongs_to :auction
end
