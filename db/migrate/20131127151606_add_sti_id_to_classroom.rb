class AddStiIdToClassroom < ActiveRecord::Migration
  def change
    add_column :classrooms, :sti_id, :integer
  end
end
