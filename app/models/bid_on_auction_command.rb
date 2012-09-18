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
    params ||= {}
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
    success = false
    unless valid?
      on_failure.call(self)
      return false
    end
    # Open a transaction
    transaction do
      begin
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
        # updates auction with new current_bid
        auction.current_bid = amount
        auction.save!
        success = true
        # close the transaction successfully
      rescue StandardError => e
        success = false
        raise ActiveRecord::Rollback
      end
    end
    if success
      on_success.call(self)
    else
      on_failure.call(self)
    end
  end

  def bid_creator
    lambda do |attributes|
      bid = auction.auction_bids.build
      bid.person = attributes[:person]
      bid.amount = attributes[:amount]
      bid.save!
      bid
    end
  end

  def transaction &block
    Auction.transaction do
      yield
    end
  end
end
