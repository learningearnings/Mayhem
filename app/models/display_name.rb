class DisplayName < ActiveRecord::Base
  attr_accessible :approved_at, :approved_by, :display_name, :person_id, :state

  belongs_to :person
  belongs_to :actioned_by, :class_name => Person

  after_create :auto_approve

  scope :approved, lambda { where(:state => "approved") }
  scope :requested, lambda { where(:state => "requested") }
  scope :rejected, lambda { where(:state => "rejected") }

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

  def most_recent_request?
    person.display_names.order("created_at DESC").limit(1).first == self
  end

  #Sets the user that approved the display name
  def approve_with_user approving_user
    #Probably is a way to do this in one call, couldn't figure it out
    self.update_attribute(:actioned_by, approving_user)
    approve!
  end

  def reject_with_user rejecting_user
    #Probably is a way to do this in one call, couldn't figure it out
    self.update_attribute(:actioned_by, rejecting_user)
    reject!
  end

  private
  def auto_approve
    if DisplayName.approved.where(:display_name => self.display_name).count > 0
      self.approve!
    end
  end
end
