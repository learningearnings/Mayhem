class FoodPersonLink < ActiveRecord::Base
  belongs_to :person
  belongs_to :food
  has_one :food_fight_match

  attr_accessible :food_id, :thrown_by_id, :person_id

  def thrown_by
    Person.find thrown_by_id
  end
end
