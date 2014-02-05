class AddIndexToPeopleForDistrictGuidAndStiId < ActiveRecord::Migration
  def change
    add_index :people, [:district_guid, :sti_id]
  end
end
