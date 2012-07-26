class Filter < ActiveRecord::Base
  attr_accessible :maximum_grade, :minimum_grade, :nickname
  has_many :school_filters
  has_many :classroom_filters
  has_many :state_filters
  has_many :person_class_filters

  validates_presence_of :minimum_grade, :maximum_grade


  def find_or_create_filter
  end


end
