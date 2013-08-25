class FoodFightMatch < ActiveRecord::Base
  attr_accessible :active, :players_turn, :initiated_by

  has_many :food_fight_players

  scope :active, where("active = ?", true)

  def winner
    players.where(:score => 1).first
  end
  
  def winner?
    winner.present?
  end

  def loser
    players - winner
  end

  def players
    food_fight_players
  end

  def player(person)
    players.find_by_person_id(person.id)
  end

  def end!
    update_attribute(:active, true)
  end

  def turn
    if players_turn
      FoodFightPlayer.find players_turn
    else
      FoodFightPlayer.find initiated_by
    end
  end

  def change_turn
    update_attributes(:players_turn => waiting_player.id)
  end

  def waiting_player
    (players - [turn]).first
  end
end
