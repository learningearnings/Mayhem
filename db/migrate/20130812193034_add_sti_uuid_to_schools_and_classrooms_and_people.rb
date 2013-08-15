class AddStiUuidToSchoolsAndClassroomsAndPeople < ActiveRecord::Migration
  def change
    add_column :schools, :sti_uuid, :string
    add_column :classrooms, :sti_uuid, :string
    add_column :people, :sti_uuid, :string
  end
end
