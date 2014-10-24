class AddCurrentVersionFieldsToDistricts < ActiveRecord::Migration
  def change
    add_column :districts, :current_student_version, :integer, limit: 8
    add_column :districts, :current_roster_version, :integer, limit: 8
    add_column :districts, :current_section_version, :integer, limit: 8
    add_column :districts, :current_staff_version, :integer, limit: 8
  end
end
