class PersonFoodSchoolLink < ActiveRecord::Base
  attr_accessible :school_id, :person_id
  belongs_to :person
  belongs_to :school
end
