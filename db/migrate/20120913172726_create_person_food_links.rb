class CreatePersonFoodLinks < ActiveRecord::Migration
  def change
    create_table :person_food_links do |t|
      t.integer :food_id
      t.integer :person_id

      t.timestamps
    end
  end
end
