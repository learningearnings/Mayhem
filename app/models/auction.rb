class Auction < ActiveRecord::Base
  validates :product_id, numericality: true
  validates :person_id, presence: true
  validates :end_date, date: { after: :start_date }
  validates :current_bid, numericality: true
  validates :auction_type, inclusion: { in: ["traditional"] }

  after_initialize :set_defaults
  just_define_datetime_picker :start_date, :add_to_attr_accessible => true
  just_define_datetime_picker :end_date, :add_to_attr_accessible => true

  belongs_to :product, class_name: "Spree::Product", foreign_key: :product_id
  belongs_to :creator, class_name: "Person", foreign_key: :person_id
  has_many :auction_bids
  has_many :states, :through => :auction_state_links
  has_many :auction_state_links
  has_many :schools, :through => :auction_school_links
  has_many :auction_school_links
  has_many :auction_zip_codes

  attr_accessible :person_id, :state_ids, :school_ids, :start_date, :end_date, :current_bid, :auction_type, :min_grade, :max_grade, :product_id, :starting_bid, :zip_codes, :auction_zip_code_ids, as: :le_admin
  attr_accessible :person_id, :state_ids, :school_ids, :start_date, :end_date, :current_bid, :auction_type, :min_grade, :max_grade, :product_id, :starting_bid, :zip_code, :auction_zip_code_ids

  scope :active, where("NOW() BETWEEN start_date AND end_date")
  scope :not_notified, where("notified IS NOT TRUE")
  scope :unfulfilled, where("fulfilled IS NOT TRUE")
  scope :ended,  where("NOW() >= end_date")
  scope :upcoming,  where("NOW() < start_date")
  scope :for_school,   lambda {|school| joins({:auction_school_links => :school}).where("auction_school_links.school_id = ?", school.id)}
  scope :for_state,    lambda {|state|  joins({:auction_state_links => :state}).where("auction_state_links.state_id = ?", state.id)}
  scope :for_zip,      lambda {|zip|    joins(:auction_zip_codes).where("auction_zip_codes.zip_code= ?", zip) }
  scope :within_grade, lambda {|grade|  where("? BETWEEN min_grade AND max_grade", grade) }
  scope :no_min_grade, where("min_grade IS NULL")
  scope :no_max_grade, where("max_grade IS NULL")

  def self.viewable_for(person)
    # TODO: Actually make this cleaner and faster
    ((active.for_school(person.school) |
     active.for_state(person.school.state) |
     active.for_zip(person.school.zip)) +
     active.within_grade(person.grade) +
     active.no_min_grade +
     active.no_max_grade).uniq
  end

  def global?
    !schools.present? && !states.present? && !auction_zip_codes.present?
  end

  def grade_range
    self.min_grade..self.max_grade
  end

  def grades
    self.grade_range.collect do |g| [g,School::GRADE_NAMES[g]] end
  end

  def open_bids
    auction_bids.where(status: 'open')
  end

  def to_s
    if product.present?
      "Auction for #{product.name}"
    else
      "No Product"
    end
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

  def notify!
    update_attribute(:notified, true)
  end

  def fulfill!
    update_attribute(:fulfilled, true)
  end

  def set_local
    created_locally = true
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
    self.starting_bid ||= BigDecimal('1')
    self.auction_type ||= "traditional"
  end
end
