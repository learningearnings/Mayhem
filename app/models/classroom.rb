require 'basic_statuses'

class Classroom < ActiveRecord::Base
  state_machine :status, :initial => :active do
  end

  include BasicStatuses

  has_many :person_school_classroom_links, :conditions => {:status => 'active'}
  has_many :students, :through => :person_school_classroom_links, :conditions => {:status => 'active'}
  has_many :teachers, :through => :person_school_classroom_links, :conditions => {:status => 'active'}

  attr_accessible :name, :status
  validates_presence_of :name

end
