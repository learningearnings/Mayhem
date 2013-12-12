class AddStudentIndexToOtuCode < ActiveRecord::Migration
  def change
    add_index :otu_codes, [:student_id, :active]
  end
end
