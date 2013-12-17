class DelayedReport < ActiveRecord::Base
  attr_accessible :person_id, :report_data, :state
  belongs_to :person
    state_machine :status, :initial => :pending do
      event :process do
        transition :pending => :processing
      end
      event :complete do
        transition :processing => :complete
      end
    end
end
