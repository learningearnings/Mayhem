class Vote

  attr_accessible :person_id, :poll_choice_id

  belongs_to :person
  belongs_to :poll_choice

end
