class AuctionSchoolLink < ActiveRecord::Base

  belongs_to :auction
  belongs_to :school

  attr_accessible :school_id, :auction_id
end
