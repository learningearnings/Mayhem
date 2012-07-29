require 'basic_statuses'

class PersonSchoolLink < ActiveRecord::Base
  scope :active_status, where(:status => 'active')
  scope :not_this_id, where("id != #{@id}")
  state_machine :status, :initial => :active do
  end
  include BasicStatuses

  belongs_to :school
  belongs_to :person

  has_many :person_school_classroom_links
  has_many :classrooms, :through => :person_school_classroom_links, :source => :classroom

  attr_accessible :person_id, :school_id, :status
  validates_presence_of :person_id, :school_id
  validate :validate_unique_with_status

  def link(d)
    if d && d.is_a?(Hash)
      self.school_id = d[:school_id] if d[:school_id]
      self.person_id = d[:person_id] if d[:person_id]
      self.school_id = d[:school].id if d[:school]
      self.person_id = d[:person].id if d[:person]
    end
  end


################### Validations ########################

#
# There can be an unlimited number of person_id -> school_id combinations that *don't* have status == "active"
# but only one active one for a person -> school combination
def validate_unique_with_status
  psl = PersonSchoolLink.where(:person_id => self.person_id, :school_id => self.school_id, :status => 'active')
  if self.id
    psl = psl.where("id != #{self.id}")
  end
  if psl.length > 0
    errors.add(:status, "Person is already associated with this school")
  end
end





end
