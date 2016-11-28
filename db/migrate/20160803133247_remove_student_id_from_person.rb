class RemoveStudentIdFromPerson < ActiveRecord::Migration
  def up
    remove_column :people, :student_id
  end

  def down
    add_column :people, :student_id, :integer
  end
end
