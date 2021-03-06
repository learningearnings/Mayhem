class AuctionBid < ActiveRecord::Base
  belongs_to :auction
  belongs_to :person
  validates :auction_id, numericality: true
  validates :person_id, numericality: true
  validates :amount, positive_decimal: true
  validates :status, inclusion: { in: ["open", "invalidated"] }

  attr_accessible :person_id, :amount, :status, :auction_id

  scope :before, lambda{|time| where("created_at < ?", time) }
  scope :status_open, where(:status => "open")
  scope :status_invalidated, where(:status => "invalidated")

  state_machine :status, initial: :open do
    event :invalidate! do
      transition [:open] => :invalidated
    end
    state :open
    state :invalidated
  end
end
