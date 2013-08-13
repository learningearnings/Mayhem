class PollChoice

  attr_accessible :name, :poll_id

  has_many :votes
  belongs_to :poll

end
