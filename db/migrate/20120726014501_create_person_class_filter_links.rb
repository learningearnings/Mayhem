class CreatePersonClassFilterLinks < ActiveRecord::Migration
  def change
    create_table :person_class_filter_links do |t|
      t.integer :person_class
      t.integer :filter_id

      t.timestamps
    end
  end
end
