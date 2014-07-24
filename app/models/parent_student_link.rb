class ParentStudentLink < ActiveRecord::Base
  attr_accessible :parent_id, :status, :student_id
  belongs_to :parent
  belongs_to :student
  before_create :set_guid

  state_machine :state, :initial => :unlinked do
    event :link do
      transition [:unlinked] => :linked
    end

    state :linked do
      validates_presence_of :parent
    end
  end

  private
  def set_guid
    write_attribute :guid, UUIDTools::UUID.random_create.to_s
  end
end
