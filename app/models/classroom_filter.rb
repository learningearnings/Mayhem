class ClassroomFilter < ActiveRecord::Base

#  belongs_to :classroom
  belongs_to :filter

  attr_accessible :classroom_id, :filter_id

  validates_presence_of :filter_id


end
