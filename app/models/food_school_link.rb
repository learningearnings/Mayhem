class FoodSchoolLink < ActiveRecord::Base
  attr_accessible :school_id, :food_id
  belongs_to :school
  belongs_to :food
end
