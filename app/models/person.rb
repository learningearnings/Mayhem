require "basic_statuses"

class Person < ActiveRecord::Base
  include BasicStatuses
  has_many :messages
  has_one  :user
  has_many :person_school_links, :inverse_of => :person

  attr_accessible :dob, :first_name, :grade, :last_name
  validates_presence_of :first_name, :last_name, :grade

  # Relationships
  def person_school_links(status = :status_active)
    PersonSchoolLink.where(person_id: self.id).send(status)
  end

  def person_school_classroom_links(status = :status_active)
    PersonSchoolClassroomLink.joins(:person_school_link).merge(person_school_links(status)).send(status)
  end

  def schools(status = :status_active)
    School.joins(:person_school_links).merge(person_school_links(status)).send(status)
  end

  def classrooms(status = :status_active)
#    Classroom.joins(:person_school_classroom_links).merge(person_school_classroom_links(status)).send(status)
    Classroom.joins(:person_school_classroom_links).send(status)
  end
  # End Relationships

  # Allow sending a school or classroom to a person
  def <<(d)
    if d.is_a? School
      person_school_links << PersonSchoolLink.new(:school_id => d.id, :person_id => self.id)
    elsif d.is_a? Classroom
      school_id = PersonSchoolClassroomLink.find(:classroom_id => d.id, :owner => true).person_school_link.person.school_id
      if school_id
        my_school_link = PersonSchoolLink.find(:school_id, :person_id => self.id)
        if !my_school_link
          my_school_link = PersonSchoolLink.new(:school_id => school_id, :person_id => self.id)
          person_school_links << my_school_link
        end
        if my_school_link
          person_school_classroom_links << PersonSchoolClassroomLink.new(:classroom_id => d.id, :person_school_link_id => my_school_link.id)
        end
      end
      PersonSchoolClassroomLink.new(:school_id => d.id, :person_id => self.id)
    end
  end


end
