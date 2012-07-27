class Person < ActiveRecord::Base

  has_one :user
  attr_accessible :dob, :first_name, :grade, :last_name
  has_many :messages

  state_machine :status, :initial => :new do
#    after_transition :new => :active, :do => :after_activate

    event :activate do
      transition [:new, :inactive] => :active
    end

    event :deactivate do
      transition [:new, :active] => :inactive
    end

    state :new
    state :active
    state :inactive
  end

  def after_activate
    # do something after going from state 'new' to 'active'
  end

end
