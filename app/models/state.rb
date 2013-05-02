class State < ActiveRecord::Base
  attr_accessible :abbr, :name

  has_many :state_filter_links, :inverse_of => :states
  has_many :filters, :through => :state_filter_links

  has_many :school_addresses

  validates_uniqueness_of :abbr
end
