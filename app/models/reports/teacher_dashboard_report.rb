module Reports
  class TeacherDashboardReport
    attr_reader :teacher
    attr_accessor :student_login_count, :teacher_login_count, :total_student_count, :total_teacher_count

    def initialize options = {}
      @teacher = options.fetch(:teacher)
    end

    def generate
      @student_login_count = LoginEvent.created_between(30.days.ago, Time.zone.now).where(school_id: teacher.school.id, user_type: "Student").pluck(:user_id).uniq.count
      @teacher_login_count = LoginEvent.created_between(30.days.ago, Time.zone.now).where(school_id: teacher.school.id, user_type: "Teacher").pluck(:user_id).uniq.count
      @total_student_count = teacher.school.students.count
      @total_teacher_count = teacher.school.teachers.count
      self
    end
  end
end
