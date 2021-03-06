class Address < ActiveRecord::Base
  attr_accessible :line1, :line2, :city, :state_id, :zip, :latitude, :longitude, :state

  belongs_to :state
  belongs_to :addressable, :polymorphic => true
  ZIP_REGEX = /(^\d{5}([\-]\d{4})?$)|(^\w\d\w\s?\d\w\d$)/
#  ZIP_REGEX   = /^\d{5}([\-]\d{4})?$/

  validates_format_of :zip, :with => ZIP_REGEX, :message => 'is invalid'

  validates_presence_of :state_id

  def geocode_address
    "#{line1}, #{city} #{state} #{zip}"
  end

  def city_and_state
    [city, state.abbr].join(", ")
  end
end

