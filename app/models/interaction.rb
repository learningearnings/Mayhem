class Interaction < ActiveRecord::Base
  belongs_to :person

  attr_accessible :ip_address
end
