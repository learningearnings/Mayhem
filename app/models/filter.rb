class Filter < ActiveRecord::Base
  attr_accessible :maximum_grade, :minimum_grade, :nickname
  has_many :school_filter_links, :inverse_of => :filter
  has_many :classroom_filter_links, :inverse_of => :filter
  has_many :state_filter_links, :inverse_of => :filter
  has_many :person_class_filter_links, :inverse_of => :filter

  has_many :schools, :through => :school_filter_links, :inverse_of => :school_filter_links
  has_many :classrooms, :through => :classroom_filter_links, :inverse_of => :classroom_filter_links
  has_many :states, :through => :state_filter_links, :inverse_of => :state_filter_links
#  has_many :person_classes, :class_name => 'PersonClassFilterLink', :inverse_of => :filter

  accepts_nested_attributes_for :school_filter_links, :classroom_filter_links, :state_filter_links, :person_class_filter_links

  validates_presence_of :minimum_grade, :maximum_grade
end
