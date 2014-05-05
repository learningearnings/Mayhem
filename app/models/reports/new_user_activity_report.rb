module Reports
  class NewUserActivityReport

    def run
      csv = CSV.generate do |csv|
        csv << ["", "", "Total Teachers", "Active Teachers", "New Teachers", "Total Students", "Active Students", "New Students", "Total Reemptions", "Total Outstanding Credits", "Credits Issued", "Credits Redeemed"]

        # Totals system wide
        csv_array = []
        csv_array << "Total"
        csv_array << ""
        csv_array << total(Teacher)
        csv_array << active(Teacher)
        csv_array << new(Teacher)
        csv_array << total(Student)
        csv_array << active(Student)
        csv_array << new(Student)
        csv_array << total_redemptions(RewardDelivery)
        csv << csv_array

        # By Grade
        csv << ["By Grade"]
        School::GRADES.each do |grade|
          teacher_scope = Teacher.where(grade: grade)
          student_scope = Student.where(grade: grade)
          csv_array = []
          csv_array << grade
          csv_array << ""
          csv_array << total(teacher_scope)
          csv_array << active(teacher_scope)
          csv_array << new(teacher_scope)
          csv_array << total(student_scope)
          csv_array << active(student_scope)
          csv_array << new(student_scope)
          csv_array << total_redemptions(RewardDelivery.joins(:to).where(to: {grade: grade}))
          csv << csv_array
        end

        csv << ["By School"]
        # By School
        School.find_each do |school|
          teacher_scope = school.teachers
          student_scope = school.students
          csv_array = []
          csv_array << school.name
          csv_array << ""
          csv_array << total(teacher_scope)
          csv_array << active(teacher_scope)
          csv_array << new(teacher_scope)
          csv_array << total(student_scope)
          csv_array << active(student_scope)
          csv_array << new(student_scope)
          csv_array << total_redemptions(RewardDelivery.where(from_id: school.teachers.pluck(:id)))
          csv << csv_array
        end
      end
      csv
    end

    private
    def total scope
      scope.count
    end

    def active scope
      scope.recently_logged_in.count
    end

    def new scope
      scope.created_between(7.days.ago, Time.zone.now).count
    end

    def total_redemptions scope
      scope.except_refunded.count
    end
  end
end
