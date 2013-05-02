class AddSchoolToClassroom < ActiveRecord::Migration
  def change
    add_column :classrooms, :school_id, :integer
    remove_column :person_class_filter_links, :person_class
    add_column :person_class_filter_links, :person_class, :string, :limit => 25
  end
end
