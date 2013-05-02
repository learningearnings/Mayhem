class UploadedUser < ActiveRecord::Base
  attr_accessible :approved_by_id, :batch_name, :created_by_id, :email, :first_name, :grade, :last_name, :message, :password, :person_id, :school_id, :state, :type, :username, :gender
  belongs_to :created_by_person, :foreign_key => :created_by_id, :class_name => "Person"
  belongs_to :approved_by_person, :foreign_key => :approved_by_id, :class_name => "Person"
  belongs_to :school
  belongs_to :person



  state_machine :state, :initial => :new do
    event :confirm do
      transition [:new, :denied] => :confirmed
    end
    event :deny do
      transition [:new, :confirmed] => :denied
    end
    event :approve do
      transition [:confirmed] => :approved
    end
    event :reject do
      transition [:confirmed, :denied] => :rejected
    end
    event :remove do
      transition [:new,:confirmed, :denied,:rejected] => :removed
    end
    state :new
    state :confirmed
    state :denied
    state :approved
    state :removed
    state :rejected
  end


end
