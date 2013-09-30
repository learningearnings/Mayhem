class CreateFoodPersonLinks < ActiveRecord::Migration
  def up
    create_table :food_person_links do |t|
      t.integer :person_id
      t.integer :thrown_by_id
      t.integer :food_id
      t.timestamps
    end
  end

  def down
    drop_table :food_person_links
  end
end
