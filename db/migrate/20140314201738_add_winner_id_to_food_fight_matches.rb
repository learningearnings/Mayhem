class AddWinnerIdToFoodFightMatches < ActiveRecord::Migration
  def change
    add_column :food_fight_matches, :winner_id, :integer
  end
end
