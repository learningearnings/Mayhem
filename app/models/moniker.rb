class Moniker < ActiveRecord::Base
  attr_accessible :approved_at, :approved_by, :moniker, :person_id, :state

  belongs_to :person
  belongs_to :actioned_by, :class_name => Person

  after_create :auto_approve

  scope :approved, lambda { where(:state => "approved") }
  scope :requested, lambda { where(:state => "requested") }
  scope :rejected, lambda { where(:state => "rejected") }

  state_machine :state, :initial => :requested do
    before_transition :on => :approve do |moniker_record|
      moniker_record.approved_at = Time.now
    end
    event :approve do
      transition all => [:approved]
    end
    event :reject do
      transition all => [:rejected]
    end
  end

  def most_recent_request?
    person.monikers.order("created_at DESC").limit(1).first == self
  end

  #Sets the user that approved the moniker
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
    if !self.person.is_a? Student
      self.approve!
    end
  end
end
