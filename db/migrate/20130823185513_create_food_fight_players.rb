class CreateFoodFightPlayers < ActiveRecord::Migration
  def change
    create_table :food_fight_players do |t|
      t.integer :food_fight_match_id
      t.integer :person_id
      t.integer :score, :default => 0
      t.integer :questions_answered, :default => 0
      t.timestamps
    end
  end
end
