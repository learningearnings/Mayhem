require 'active_support/concern'

module BasicStatuses
  extend ActiveSupport::Concern
  included do
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
  end
end
