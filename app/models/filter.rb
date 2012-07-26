class Filter < ActiveRecord::Base
  attr_accessible :maximum_grade, :minimum_grade, :nickname
  has_many :school_filter_links
  has_many :classroom_filter_links
  has_many :state_filter_links
  has_many :person_class_filter_links

  validates_presence_of :minimum_grade, :maximum_grade





end
