class Auction < ActiveRecord::Base
  validates :product_id, numericality: true
  validates :end_date, date: { after: :start_date }
  validates :current_bid, numericality: true
  validates :auction_type, inclusion: { in: ["traditional"] }
  after_initialize :set_defaults

  protected
  def set_defaults
    self.current_bid ||= BigDecimal('0')
  end
end
