require 'basic_statuses'

class Classroom < ActiveRecord::Base
  state_machine :status, :initial => :active do
  end
  include BasicStatuses

  belongs_to :school

  has_many :person_school_classroom_links
  has_many :classroom_filter_links, :inverse_of => :classrooms
  has_many :filters, :through => :classroom_filter_links

  has_many :classroom_product_links
  has_many :products, :through => :classroom_product_links, :class_name => "Spree::Product", :source => :spree_product


  attr_accessible :name, :status, :school_id, :legacy_classroom_id, :status
  attr_accessible :name, :status, :school_id, :legacy_classroom_id, :created_at, :status, :as => :admin

  validates_presence_of :name
  validates_uniqueness_of :sti_uuid, allow_blank: true

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

  def assign_owner(person_or_person_school_link)
    person_school_classroom_links.where(:owner => true).each do |link|
      link.owner = false
      link.save
    end
    if person_or_person_school_link.is_a?(Person)
      person_school_link = PersonSchoolLink.where(person_id: person_or_person_school_link.id, school_id: school.id).first
    else
      person_school_link = person_or_person_school_link
    end
    this_persons_links = person_school_classroom_links.where(person_school_link_id: person_school_link.id)
    if this_persons_links.empty?
      person_school_classroom_links << PersonSchoolClassroomLink.create(:person_school_link_id => person_school_link.id,
                                                                 :classroom_id => self.id,
                                                                 :owner => true)
    else
      this_persons_links.each do |link|
        link.owner = true
        link.save
      end
    end
  end

  def to_s
    name
  end
end
