class FoodFightPlayer < ActiveRecord::Base
  attr_accessible :food_fight_match_id, :person_id, :score, :questions_answered
  belongs_to :food_fight_match
  belongs_to :person
 
  def winner?
    score >= 1 && score > opponent.score && opponent.score < opponent.questions_answered
  end

  def loser?
    !winner?
  end

  def opponent
    (food_fight_match.players - [self]).first
  end

  def match
    food_fight_match
  end

  def add_score
    update_attributes(:score => score + 1)
  end
end
