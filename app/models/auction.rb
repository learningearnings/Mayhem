class Auction < ActiveRecord::Base
  validates :product_id, numericality: true
  validates :end_date, date: { after: :start_date }
  validates :current_bid, numericality: true
  validates :auction_type, inclusion: { in: ["traditional"] }
  after_initialize :set_defaults

  belongs_to :product, class_name: "Spree::Product", foreign_key: :product_id

  attr_accessible :start_date, :end_date, :current_bid, :auction_type, :product_id, as: :le_admin

  scope :active, where("NOW() BETWEEN start_date AND end_date")

  protected
  def set_defaults
    self.current_bid  ||= BigDecimal('0')
    self.auction_type ||= "traditional"
  end
end
