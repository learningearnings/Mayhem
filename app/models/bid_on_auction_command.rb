require_relative 'active_model_command'
require_relative '../validators/positive_decimal_validator'
require_relative '../validators/greater_than_validator'

class BidOnAuctionCommand < ActiveModelCommand
  attr_accessor :person, :auction, :amount, :credit_manager, :on_success, :on_failure

  validates :amount, positive_decimal: true, greater_than: :auction_current_bid
  validates :person, presence: true
  validates :auction, presence: true
  validates :credit_manager, presence: true

  def initialize params={}
    @person  = params[:person]
    @auction = params[:auction]
    @amount  = params[:amount]
    @credit_manager = params[:credit_manager]
    # Set up default no-op callbacks
    @on_success = lambda{|command|}
    @on_failure = lambda{|command|}
  end

  def auction_current_bid
    auction && auction.current_bid
  end

  def execute!
    # Open a transaction
    begin
      transaction do
        open_bids = auction.open_bids
        open_bids.each do |bid|
          # invalidate existing bids
          bid.invalidate!
          # refund money for existing bids
          credit_manager.transfer_credits_from_hold_to_checking(bid.person, bid.amount)
        end
        # create a new bid
        bid_creator.call(amount: amount, person: person, auction: auction)
        # move money from the bidder's main account into their holding account
        credit_manager.transfer_credits_from_checking_to_hold(person, amount)
        # close the transaction successfully
      end
    rescue
      on_failure.call(self)
      return false
    end

    on_success.call(self)
  end

  def bid_creator
    lambda{ |attributes| AuctionBid.create(attributes) }
  end

  def transaction &block
    Auction.transaction do
      yield
    end
  end
end
