require "basic_statuses"
require 'macro_reflection_relation_facade'

class Person < ActiveRecord::Base
  include BasicStatuses
  has_one  :user, :class_name => Spree::User, :autosave => true
  has_many :posts
  has_many :sent_messages, class_name: "Message", foreign_key: "from_id"
  has_many :received_messages, class_name: "Message", foreign_key: "to_id"
  #has_many :classrooms, :through => :person_school_classroom_links
  has_many :person_school_links
  has_many :person_school_classroom_links
  has_many :buck_batches, :through => :person_buck_batch_links
  has_many :person_buck_batch_links

  
  def favorite_foods
    links = FoodSchoolLink.find_all_by_person_id(self.id)
    links.sort_by{|x| x.food_id}.uniq{|x| x.food_id}.map{|x| x.food}.first(3)
  end

  def favorite_schools
    links = FoodSchoolLink.find_all_by_person_id(self.id)
    links.sort_by{|x| x.school_id}.uniq{|x| x.school_id}.map{|x| x.school}.first(3)
  end

  def food_schools
    School.joins(:person_food_school_links).where(person_food_school_links: { id: person_food_school_links.map(&:id) })
  end

  delegate :avatar, to: :user
  delegate :username, :username= , to: :user

  attr_accessible :dob, :first_name, :grade, :last_name, :legacy_user_id, :user
  validates_presence_of :first_name, :last_name

  # Relationships
  def person_school_links(status = :status_active)
    MacroReflectionRelationFacade.new(PersonSchoolLink.where(person_id: self.id).send(status))
  end

  def person_school_classroom_links(status = :status_active)
    PersonSchoolClassroomLink.joins(:person_school_link).where(person_school_link: { id: person_school_links(status).map(&:id) }).send(status)
  end

  def schools(status = :status_active)
    School.joins(:person_school_links).where(person_school_links: { id: person_school_links(status).map(&:id) }).send(status).order('created_at desc')
  end

  def classrooms(status = :status_active)
    Classroom.joins(:person_school_classroom_links).where(person_school_classroom_links: { id: person_school_classroom_links(status).map(&:id) }).send(status)
  end
  # End Relationships

  def full_name
    self.first_name + ' ' + self.last_name
  end

  def to_s
    full_name
  end

  def store_code
    nil
  end


  # Allow sending a school or classroom to a person
  def <<(d)
    if d.is_a? School
      PersonSchoolLink.create(:school_id => d.id, :person_id => self.id)
    elsif d.is_a? Classroom
      psl = PersonSchoolLink.find_or_create_by_school_id_and_person_id(d.school_id, self.id)
      PersonSchoolClassroomLink.create(:classroom_id => d.id, :person_school_link_id => psl.id)
    end
  end
end
