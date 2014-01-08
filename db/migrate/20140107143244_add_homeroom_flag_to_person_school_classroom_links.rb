class AddHomeroomFlagToPersonSchoolClassroomLinks < ActiveRecord::Migration
  def change
    add_column :person_school_classroom_links, :homeroom, :boolean
  end
end
