class AddIndexToClassroomsForDistrictGuidAndStiId < ActiveRecord::Migration
  def change
    add_index :classrooms, [:district_guid, :sti_id]
  end
end
