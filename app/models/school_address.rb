class SchoolAddress < ActiveRecord::Base
  attr_accessible :address1, :address2, :city, :state_id, :zip
end
