class AddLegacyClassroomIdToClassrooms < ActiveRecord::Migration
  def change
    add_column :classrooms, :legacy_classroom_id, :integer
    add_column :classrooms, :processed, :integer
    add_column :schools, :legacy_school_id, :integer
  end
end
