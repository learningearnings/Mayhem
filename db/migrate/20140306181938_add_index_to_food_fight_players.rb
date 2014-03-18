class AddIndexToFoodFightPlayers < ActiveRecord::Migration
  def change
    add_index :food_fight_players, :food_fight_match_id
  end
end
