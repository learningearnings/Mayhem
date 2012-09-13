class PersonFoodLink < ActiveRecord::Base
  attr_accessible :person_id, :food_id
  belongs_to :person
  belongs_to :food
end
