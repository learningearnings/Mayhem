require 'basic_statuses'

class Classroom < ActiveRecord::Base
  state_machine :status, :initial => :active do
  end

  include BasicStatuses
  has_many :person_school_classroom_links

  attr_accessible :name, :status
  validates_presence_of :name

  # Roll our own Relationships (with ARel merge!)
  def person_school_links(status = :status_active)
    PersonSchoolLink.joins(:person_school_classroom_links).send(status)
  end

  def students(status = :status_active)
    Student.joins(:person_school_links).merge(person_school_links(status)).send(status)
  end

  def teachers(status = :status_active)
    Teacher.joins(:person_school_classroom_links).merge(person_school_links(status)).send(status)
  end
  # END Relationships


end
