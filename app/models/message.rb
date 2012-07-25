class Message < ActiveRecord::Base
  attr_accessible :body
  belongs_to :person
end
