class CreateFoodSchoolLinks < ActiveRecord::Migration
  def change
    create_table :food_school_links do |t|
      t.integer :food_id
      t.integer :school_id
      t.integer :person_id

      t.timestamps
    end
  end
end
