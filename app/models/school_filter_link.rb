class SchoolFilterLink < ActiveRecord::Base
  belongs_to :school
  belongs_to :filter

  attr_accessible :filter_id, :school_id

  validates_presence_of :filter_id
end
