class CreateFoodFightMatches < ActiveRecord::Migration
  def change
    create_table :food_fight_matches do |t|
      t.boolean :active
      t.integer :players_turn
      t.integer :initiated_by
      t.boolean :food_thrown
      t.boolean :food_person_link_id
      t.timestamps
    end
  end
end
