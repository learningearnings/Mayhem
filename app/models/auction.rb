class Auction < ActiveRecord::Base
  validates :product_id, numericality: true
  validates :end_date, date: { after: :start_date }
  validates :current_bid, numericality: true
  validates :auction_type, inclusion: { in: ["traditional"] }
  after_initialize :set_defaults

  belongs_to :product, class_name: "Spree::Product", foreign_key: :product_id
  has_many :auction_bids

  attr_accessible :start_date, :end_date, :current_bid, :auction_type, :product_id, as: :le_admin

  scope :active, where("NOW() BETWEEN start_date AND end_date")
  scope :ended,  where("NOW() >= end_date")
  scope :upcoming,  where("NOW() < start_date")

  def open_bids
    auction_bids.where(status: 'open')
  end

  def to_s
    "Auction for #{product.name}"
  end

  def active?
    !upcoming? && !ended?
  end

  def ended?
    Time.zone.now > end_date
  end

  def upcoming?
    start_date > Time.zone.now
  end

  def status
    return 'active' if active?
    return 'ended' if ended?
    return 'upcoming' if upcoming?
  end

  def bidders
    auction_bids.map(&:person).uniq
  end

  def current_leader
    return nil unless auction_bids.any?
    auction_bids.last.person
  end

  def top_bid_at(time)
    auction_bids.before(time).last
  end

  def bid_difference_since(time)
    top_bid = top_bid_at(time)
    return BigDecimal('0') unless top_bid
    top_bid_amount = top_bid.amount
    current_bid - top_bid_amount
  end

  protected
  def set_defaults
    self.current_bid  ||= BigDecimal('0')
    self.auction_type ||= "traditional"
  end
end
