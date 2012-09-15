class DisplayName < ActiveRecord::Base
  attr_accessible :approved_at, :approved_by, :display_name, :person_id, :state

  belongs_to :person
  belongs_to :approved_by, :class_name => Person

  scope :approved, lambda { where(:state => "approved") }

  state_machine :state, :initial => :requested do
    before_transition :on => :approve do |display_name_record|
      display_name_record.approved_at = Time.now
    end
    event :approve do
      transition all => [:approved]
    end
    event :reject do
      transition all => [:rejected]
    end
  end

  #Sets the user that approved the display name
  def approve_with_user approving_user
    #Probably is a way to do this in one call, couldn't figure it out
    self.update_attribute(:approved_by, approving_user)
    approve!
  end
end
