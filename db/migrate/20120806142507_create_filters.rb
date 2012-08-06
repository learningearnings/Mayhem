class CreateFilters < ActiveRecord::Migration
  def change
    create_table :filters do |t|
      t.integer :minimum_grade
      t.integer :maximum_grade
      t.string :nickname

      t.timestamps
    end
  end
end
