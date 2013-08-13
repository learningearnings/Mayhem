class Poll < ActiveRecord::Base

  attr_accessible :title, :question
  attr_accessible :title, :question, as: :admin

  has_many :poll_choices

end
