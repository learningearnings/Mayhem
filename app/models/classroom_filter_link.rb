class ClassroomFilterLink < ActiveRecord::Base

#  belongs_to :classroom
  belongs_to :filter, :inverse_of => :classroom_filter_links 
  belongs_to :classroom

  attr_accessible :classroom_id, :filter_id

#  validates_presence_of :filter_id

  validates_uniqueness_of :classroom_id, :scope => [:filter_id], :allow_nil => true, :unless => Proc.new { |f| f.filter_id.nil? }


end
