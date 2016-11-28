class DropParentStudentsTable < ActiveRecord::Migration
  def up
    drop_table :parents_students
  end

  def down
    fail ActiveRecord::IrreversibleMigration
  end
end
