class Interaction < ActiveRecord::Base
  belongs_to :person
  before_create :set_defaults

  attr_accessible :ip_address

  protected
  def set_defaults
    self.date ||= Time.zone.now.to_date
  end
end
