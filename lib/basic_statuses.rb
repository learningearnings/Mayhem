require 'active_support/concern'

module BasicStatuses
  extend ActiveSupport::Concern
  included do
    state_machine :status, :initial => :new do
#    after_transition :new => :active, :do => :after_activate
      event :activate do
        transition [:new, :inactive, :awaiting_approval] => :active
      end
      event :deactivate do
        transition [:new, :active] => :inactive
      end
      event :set_awaiting do
        transition [:new, :active] => :awaiting_approval
      end
      state :new
      state :active
      state :inactive
    end
    scope :status_active, where(:status => 'active')
    scope :status_inactive, where(:status => 'inactive')
    scope :status_new, where(:status => 'new')
    scope :status_all, where(:status => ['new','inactive','active'])
  end
end
