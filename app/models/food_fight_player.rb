class FoodFightPlayer < ActiveRecord::Base
  attr_accessible :food_fight_match_id, :person_id, :score
  belongs_to :food_fight_match
  belongs_to :person
 
  def winner?
    score >= 1
  end

  def opponent
    (food_fight_match.players - [self]).first
  end

  def match
    food_fight_match
  end
end
