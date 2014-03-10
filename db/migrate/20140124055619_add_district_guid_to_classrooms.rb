class AddDistrictGuidToClassrooms < ActiveRecord::Migration
  def change
    add_column :classrooms, :district_guid, :string
  end
end
