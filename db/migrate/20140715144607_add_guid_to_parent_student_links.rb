class AddGuidToParentStudentLinks < ActiveRecord::Migration
  def change
    add_column :parent_student_links, :guid, :string
  end
end
