class FoodFightPlayer < ActiveRecord::Base
  attr_accessible :food_fight_match_id, :person_id, :score, :questions_answered
  belongs_to :food_fight_match
  belongs_to :person

  def winner?
    if food_fight_match.winner_id.present?
      food_fight_match.winner_id == self.id
    else
      score >= 1 && score > opponent.score && opponent.score < opponent.questions_answered
    end
  end

  def loser?
    !winner?
  end

  def opponent
    (match.players - [self]).first
  end

  def match
    food_fight_match
  end

  def add_score
    update_attributes(:score => score + 1)
  end
end
