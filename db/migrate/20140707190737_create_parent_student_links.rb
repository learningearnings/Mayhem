class CreateParentStudentLinks < ActiveRecord::Migration
  def change
    create_table :parent_student_links do |t|
      t.integer :parent_id
      t.integer :student_id
      t.string :status

      t.timestamps
    end
  end
end
