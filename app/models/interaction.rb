class Interaction < ActiveRecord::Base
  belongs_to :person
  before_create :set_defaults

  attr_accessible :ip_address

  scope :between, lambda {|start_date, end_date| where(Interaction.arel_table[:created_at].gteq(start_date).and(Interaction.arel_table[:created_at].lteq(end_date)))}

  protected
  def set_defaults
    self.date ||= Time.zone.now.to_date
  end
end
