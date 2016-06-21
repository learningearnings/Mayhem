class AddReasonToTeacherCredit < ActiveRecord::Migration
  def change
    add_column :teacher_credits, :reason, :text
  end
end
