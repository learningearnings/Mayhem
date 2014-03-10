class AddDistrictGuidToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :district_guid, :string
  end
end
