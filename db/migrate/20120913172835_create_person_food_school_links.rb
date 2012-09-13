class CreatePersonFoodSchoolLinks < ActiveRecord::Migration
  def change
    create_table :person_food_school_links do |t|
      t.integer :school_id
      t.integer :person_id

      t.timestamps
    end
  end
end
