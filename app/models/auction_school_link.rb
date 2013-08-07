class AuctionSchoolLink < ActiveRecord::Base

  belongs_to :auction
  belongs_to :school
end
