class CreatePersonSchoolLinks < ActiveRecord::Migration
  def change
    create_table :person_school_links do |t|
      t.integer :person_id
      t.integer :school_id
      t.string :status

      t.timestamps
    end
  end
end
