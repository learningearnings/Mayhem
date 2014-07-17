class AddStateToParentStudentLinks < ActiveRecord::Migration
  def change
    add_column :parent_student_links, :state, :string
  end
end
