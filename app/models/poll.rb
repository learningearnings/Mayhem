class Poll
  attr_accessible :title, :question
  has_many :poll_choices

end
