require 'basic_statuses'

class Classroom < ActiveRecord::Base
  state_machine :status, :initial => :active do
  end
  include BasicStatuses

  belongs_to :school

  has_many :person_school_classroom_links
  has_many :classroom_filter_links, :inverse_of => :classrooms
  has_many :filters, :through => :classroom_filter_links

  attr_accessible :name, :status, :school_id, :legacy_classroom_id
  attr_accessible :name, :status, :school_id, :legacy_classroom_id, :created_at, :as => :admin

  validates_presence_of :name
  validates_uniqueness_of :sti_uuid

  # Roll our own Relationships (with ARel merge!)
  def person_school_links(status = :status_active)
    PersonSchoolLink.joins(:person_school_classroom_links).where(person_school_classroom_links: { classroom_id: id }).send(status)
  end

  def students(status = :status_active)
    Student.joins(:person_school_links).where(person_school_links: { id: person_school_links(status) })
  end

  def teachers(status = :status_active)
    Teacher.joins(:person_school_links).where(person_school_links: { id: person_school_links(status) })
  end

  def owner(status = :status_active)
    Teacher.joins(:person_school_links).joins("INNER JOIN person_school_classroom_links ON person_school_classroom_links.person_school_link_id = person_school_links.id").where(person_school_links: { id: person_school_links(status) }, person_school_classroom_links: { owner: true })
  end
  # END Relationships

  def assign_owner(person_school_link)
    person_school_classroom_links.where(:owner => true).each do |link|
      link.owner = false
    end
    if person_school_classroom_links.where(person_school_link_id => t.id).count < 1
      person_school_classroom_links << PersonSchoolClassroomLink(:person_school_link_id => person_school_link.id, 
                                                                 :classroom_id => self.id,
                                                                 :owner => true)
      else
      person_school_classroom_links.where(person_id => t.id).each do
        pscl.owner = true
      end
    end
  end

  def to_s
    name
  end
end
