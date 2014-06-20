module Reports
  class TeacherDashboardReport
    attr_reader :teacher
    attr_accessor :student_login_count, :teacher_login_count, :total_student_count, :total_teacher_count, :otu_codes

    def initialize options = {}
      @teacher = options.fetch(:teacher)
    end

    def generate
      @student_login_count = LoginEvent.created_between(30.days.ago, Time.zone.now).where(school_id: teacher.school.id, user_type: "Student").pluck(:user_id).uniq.count
      @teacher_login_count = LoginEvent.created_between(30.days.ago, Time.zone.now).where(school_id: teacher.school.id, user_type: "Teacher").pluck(:user_id).uniq.count
      @total_student_count = teacher.school.students.count
      @total_teacher_count = teacher.school.teachers.count
      @otu_codes           = OtuCode.created_between(30.days.ago, Time.zone.now).for_school(teacher.school).includes(:otu_code_category)
      self
    end

    def otu_code_categories
      otu_code_category_ids = @teacher.otu_codes.pluck(:otu_code_category_id)
      array = OtuCodeCategory.where(id: otu_code_category_ids).map do |otu_code_category| 
        [
          otu_code_category.name,
          otu_codes.where(otu_code_category_id: otu_code_category.id).count
        ]
      end
      no_category_codes = otu_codes.where(otu_code_category_id: nil).count
      if no_category_codes > 0
        array << ["N/A", no_category_codes]
      end
      array
    end
  end
end
