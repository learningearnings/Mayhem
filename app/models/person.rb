require "basic_statuses"

class Person < ActiveRecord::Base
  include BasicStatuses
  has_many :person_school_links
  has_many :schools, :through => :person_school_links, :source => :school
  has_many :messages
  has_one  :user

  has_many :person_school_classroom_links,:through => :person_school_links, :conditions => {:status => 'active'}
  has_many :classrooms, :through => :person_school_classroom_links, :source => :classroom

  attr_accessible :dob, :first_name, :grade, :last_name

  validates_presence_of :first_name, :last_name, :grade
end
