class Poll < ActiveRecord::Base
  
  attr_accessible :title, :question, :active, as: :admin
  attr_accessible :title, :question, :active

  has_many :poll_choices

  scope :active, where('active = ?', true)

end
