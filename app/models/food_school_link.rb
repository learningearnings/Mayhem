class FoodSchoolLink < ActiveRecord::Base

  attr_accessible :food_id, :school_id

  belongs_to :school
  belongs_to :food

end
