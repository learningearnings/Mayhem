class AddTeacherOnlyToAvatars < ActiveRecord::Migration
  def change
    add_column :avatars, :teacher_only, :boolean, :default => false
  end
end
