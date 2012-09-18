class AuctionBid < ActiveRecord::Base
  belongs_to :auction
  belongs_to :person
  validates :auction_id, numericality: true
  validates :person_id, numericality: true
  validates :amount, positive_decimal: true
  validates :status, inclusion: { in: ["open", "invalidated"] }

  state_machine :status, initial: :open do
    event :invalidate! do
      transition [:open] => :invalidated
    end
    state :open
    state :invalidated
  end
end
