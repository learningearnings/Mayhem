class TourEvent < ActiveRecord::Base
  belongs_to :person
  before_create :set_defaults

  attr_accessible :page, :event_name, :tour_name, :tour_step, :created_at

  scope :between, lambda {|start_date, end_date| where(TourEvent.arel_table[:created_at].gteq(start_date).and(TourEvent.arel_table[:created_at].lteq(end_date)))}

  protected
  def set_defaults
    self.date ||= Time.zone.now.to_date
  end
end
