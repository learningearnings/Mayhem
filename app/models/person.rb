require "basic_statuses"

class Person < ActiveRecord::Base
  include BasicStatuses
  has_one  :user, :class_name => Spree::User
  has_many :person_school_links, :inverse_of => :person
  has_many :sent_messages, class_name: "Message", foreign_key: "from_id"
  has_many :received_messages, class_name: "Message", foreign_key: "to_id"

  delegate :avatar, to: :user

  attr_accessible :dob, :first_name, :grade, :last_name, :legacy_user_id
  validates_presence_of :first_name, :last_name

  # Relationships
  def person_school_links(status = :status_active)
    PersonSchoolLink.where(person_id: self.id).send(status)
  end

  def person_school_classroom_links(status = :status_active)
    PersonSchoolClassroomLink.joins(:person_school_link).merge(person_school_links(status)).send(status)
  end

  def schools(status = :status_active)
    School.joins(:person_school_links).merge(person_school_links(status)).send(status).order('created_at desc')
  end

  def classrooms(status = :status_active)
#    Classroom.joins(:person_school_classroom_links).merge(person_school_classroom_links(status)).send(status)
    Classroom.joins(:person_school_classroom_links).send(status)
  end
  # End Relationships

  # Allow sending a school or classroom to a person
  def <<(d)
    if d.is_a? School
      puts "School #{d.name}"
      PersonSchoolLink.create(:school_id => d.id, :person_id => self.id)
    elsif d.is_a? Classroom
      psl = PersonSchoolLink.create(:school_id => d.school_id, :person_id => self.id)
#      self.person_school_links << psl
      PersonSchoolClassroomLink.create(:classroom_id => d.id, :person_school_link_id => psl)
    end
  end
end
