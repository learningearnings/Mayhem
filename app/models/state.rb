class State < ActiveRecord::Base
  attr_accessible :abbr, :name

  validates_uniqueness_of :abbr
end
