require "basic_statuses"

class Person < ActiveRecord::Base
  include BasicStatuses
  has_many :messages
  has_one  :user
  has_many :person_school_links
  has_many :person_school_classroom_links,
           :through => :person_school_links,
           :class_name => 'PersonSchoolClassroomLink',
           :source => :person_school_classroom_links

  attr_accessible :dob, :first_name, :grade, :last_name
  validates_presence_of :first_name, :last_name, :grade

  # Relationships
  def person_school_links(status = :status_active)
    PersonSchoolLink.where(person_id: self.id).send(status)
  end

  def person_school_classroom_links(status = :status_active)
    PersonSchoolClassroomLink.joins(:person_school_links).where(person_id: self.id).send(status)
  end

  def schools(status = :status_active)
    School.joins(:person_school_links).merge(person_school_links(status)).send(status)
  end

  def person_school_classroom_links(status = :status_active)
    PersonSchoolClassroomLink.where(person_id: self.id).send(status)
  end

  def classrooms(status = :status_active)
    Classroom.merge(person_school_classroom_links(status)).send(status)
  end
  # End Relationships
end
