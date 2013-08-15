class Vote < ActiveRecord::Base

  attr_accessible :person_id, :poll_choice_id, :poll_id

  belongs_to :person
  belongs_to :poll_choice

end
