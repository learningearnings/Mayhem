class AddMinAndMaxGradeToPolls < ActiveRecord::Migration
  def change
    add_column :polls, :min_grade, :integer
    add_column :polls, :max_grade, :integer
  end
end
