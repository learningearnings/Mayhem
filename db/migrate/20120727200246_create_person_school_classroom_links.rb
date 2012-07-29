class CreatePersonSchoolClassroomLinks < ActiveRecord::Migration
  def change
    create_table :person_school_classroom_links do |t|
      t.integer :person_school_link_id
      t.string :status
      t.boolean :owner
      t.integer :classroom_id

      t.timestamps
    end
  end
end
