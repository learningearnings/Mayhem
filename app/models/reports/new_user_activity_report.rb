module Reports
  class NewUserActivityReport

    def run
      csv = CSV.generate do |csv|
        csv << ["", "", "Total Teachers", "Active Teachers", "New Teachers", "Total Students", "Active Students", "New Students", "Total Reemptions", "Total Outstanding Credits", "Credits Issued", "Credits Redeemed"]

        # Totals system wide
        teacher_scope = Teacher
        student_scope = Student
        reward_delivery_scope = RewardDelivery
        otu_code_scope = OtuCode
        csv << build_row("Total", teacher_scope, student_scope, reward_delivery_scope, otu_code_scope)

        # By Grade
        csv << ["By Grade"]
        School::GRADES.each do |grade|
          teacher_scope = Teacher.where(grade: grade)
          student_scope = Student.where(grade: grade)
          otu_code_scope = OtuCode.for_grade(grade)
          reward_delivery_scope = RewardDelivery.joins(:to).where(to: {grade: grade})
          csv << build_row(grade, teacher_scope, student_scope, reward_delivery_scope, otu_code_scope)
        end

        csv << ["By School"]
        # By School
        School.find_each do |school|
          teacher_scope = school.teachers
          student_scope = school.students
          otu_code_scope = OtuCode.for_school(school)
          reward_delivery_scope = RewardDelivery.where(from_id: school.teachers.pluck(:id))
          csv << build_row(school.name, teacher_scope, student_scope, reward_delivery_scope, otu_code_scope)
        end
      end
      csv
    end

    private
    def build_row title, teacher_scope, student_scope, reward_delivery_scope, otu_code_scope
      [].tap do |csv_array|
        csv_array << title
        csv_array << ""
        csv_array << total(teacher_scope)
        csv_array << active(teacher_scope)
        csv_array << new(teacher_scope)
        csv_array << total(student_scope)
        csv_array << active(student_scope)
        csv_array << new(student_scope)
        csv_array << total_redemptions(reward_delivery_scope)
        csv_array << otu_code_scope.active.sum(:points)
        csv_array << otu_code_scope.sum(:points)
        csv_array << otu_code_scope.inactive.sum(:points)
      end
    end

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
