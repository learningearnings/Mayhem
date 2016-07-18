class AddStudentToPerson < ActiveRecord::Migration
  def change
    add_column :people, :student_id, :integer
  end
end
