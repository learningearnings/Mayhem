class CreateFoodFightMatches < ActiveRecord::Migration
  def change
    create_table :food_fight_matches do |t|
      t.boolean :active
      t.integer :players_turn
      t.timestamps
    end
  end
end
