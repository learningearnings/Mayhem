class Person < ActiveRecord::Base

  has_one :user
  attr_accessible :dob, :first_name, :grade, :last_name

end
