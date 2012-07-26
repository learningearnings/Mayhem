class CreatePersonClassFilters < ActiveRecord::Migration
  def change
    create_table :person_class_filters do |t|
      t.integer :person_class
      t.integer :filter_id

      t.timestamps
    end
  end
end
