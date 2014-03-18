class AddDistrictGuidToPeople < ActiveRecord::Migration
  def change
    add_column :people, :district_guid, :string
  end
end
