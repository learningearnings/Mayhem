class CodeEntryFailure < ActiveRecord::Base
  belongs_to :person
  attr_accessible :person_id

  scope :within_five_minutes, lambda { where("created_at >= ?", 5.minutes.ago) }
end
