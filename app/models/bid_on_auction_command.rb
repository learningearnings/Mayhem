require_relative 'active_model_command'
require_relative '../validators/positive_decimal_validator'
require_relative '../validators/greater_than_validator'
require 'action_view'
require 'active_record/errors'

class BidOnAuctionCommand < ActiveModelCommand
  class FailedToCreateAuctionBid < StandardError
  end

  include ActionView::Helpers::UrlHelper
  attr_accessor :person, :auction, :amount, :credit_manager, :on_success, :on_failure, :failure_reason

  validates :amount, positive_decimal: true, greater_than: :auction_current_bid
  validates :person, presence: true
  validates :auction, presence: true
  validate :auction_active
  validate :high_bidder_not_current_bidder
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

  def auction_active
    errors.add(:auction, 'has already ended.') unless auction && auction.active?
  end

  def high_bidder_not_current_bidder
    errors.add(:you, 'are already the high bidder') unless auction && auction.current_leader != person
  end

  def execute!
    success = false
    open_bids = []
    unless valid?
      @failure_reason = errors.full_messages.to_sentence.downcase.capitalize
      on_failure.call(self)
      return false
    end
    # Open a transaction
    transaction do
      begin
        open_bids = auction.open_bids
        if open_bids.empty?
          # If we're the first bid, we must be greater than or equal to the starting bid
          raise "must be greater than or equal to starting bid" if @amount < @auction.starting_bid
        end
        open_bids.each{|bid| invalidate_bid(bid) }
        create_new_bid_and_transfer_money
        update_auction_with_current_bid
        success = true
        # close the transaction successfully
      rescue StandardError => e
        success = false
        @failure_reason = e.message
        raise ActiveRecord::Rollback
      end
    end
    if success
      # Notify previous open_bids that they've been outbid
      open_bids.each{|bid| notify_of_outbid(bid) }
      on_success.call(self)
    else
      on_failure.call(self)
    end
  end

  def invalidate_bid(bid)
    # invalidate existing bid
    bid.invalidate!
    # refund money for existing bid
    credit_manager.transfer_credits_from_hold_to_checking(bid.person, bid.amount)
  end

  def create_new_bid_and_transfer_money
    # create a new bid
    bid_creator.call(amount: amount, person: person, auction: auction)
    # move money from the bidder's main account into their holding account
    success = credit_manager.transfer_credits_from_checking_to_hold(person, amount)
    raise "You do not have enough credits to bid this amount!" unless success
  end

  def update_auction_with_current_bid
    # updates auction with new current_bid
    auction.current_bid = amount
    auction.save!
  end

  def notify_of_outbid(bid)
    body = "You've been outbid on the following auction: #{link_to(auction.to_s, auction_path(auction))}."

    message_creator.call(from: person,
                         to: bid.person,
                         subject: "You've been outbid on an auction",
                         body: body,
                         category: 'auctions')
  end

  protected
  def bid_creator
    lambda do |attributes|
      bid = auction.auction_bids.build
      bid.person = attributes[:person]
      bid.amount = attributes[:amount]
      bid.save!
      bid
    end
  end

  def message_creator
    ->(params) { Message.create params }
  end

  def transaction &block
    Auction.transaction do
      yield
    end
  end

  # NOTE: We can use rails here but...slow tests
  def auction_path(auction)
    "/auctions/#{auction.id}"
  end
end
