class Address < ActiveRecord::Base
  attr_accessible :line1, :line2, :city, :state, :zip

  belongs_to :addressable, :polymorphic => true
  ZIP_REGEX   = /^\d{5}([\-]\d{4})?$/

  validates_format_of :zip, :with => ZIP_REGEX, :message => 'is invalid'

  def geocode_address
    "#{line1}, #{city} #{state} #{zip}"
  end
end

