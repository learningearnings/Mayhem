module Reports
  class TeacherActivityReport
    def initialize
    end

    def run
      csv = CSV.generate do |csv|
        csv << ["State", "School", "Teacher", "Last Login"]
        Teacher.find_each do |teacher|
          school = teacher.school
          if school
            csv << [school.state.name, school.name, teacher.name, teacher.last_sign_in_at]
          else
            csv << ["N/A", "N/A", teacher.name, teacher.last_sign_in_at]
          end
        end
      end
    end
  end
end
