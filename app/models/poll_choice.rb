class PollChoice < ActiveRecord::Base

  attr_accessible :choice, :poll_id

  has_many :votes
  belongs_to :poll

end
