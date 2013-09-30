class SchoolFilterLink < ActiveRecord::Base
  belongs_to :school
  belongs_to :filter, :inverse_of => :school_filter_links

  attr_accessible :filter_id, :school_id

#  validates_presence_of :filter_id

  validates_uniqueness_of :school_id, :scope => [:filter_id], :allow_nil => true, :unless => Proc.new { |f| f.filter_id.nil? }


end
