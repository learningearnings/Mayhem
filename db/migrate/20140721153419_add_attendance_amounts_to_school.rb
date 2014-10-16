class AddAttendanceAmountsToSchool < ActiveRecord::Migration
  def change
    add_column :schools, :weekly_perfect_attendance_amount, :integer
    add_column :schools, :monthly_perfect_attendance_amount, :integer
    add_column :schools, :weekly_no_tardies_amount, :integer
    add_column :schools, :monthly_no_tardies_amount, :integer
    add_column :schools, :weekly_no_infractions_amount, :integer
    add_column :schools, :monthly_no_infractions_amount, :integer
  end
end
