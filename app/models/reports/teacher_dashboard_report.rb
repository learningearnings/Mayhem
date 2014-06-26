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
      otu_code_bucket = @teacher.school.otu_codes.joins(:student)
      otu_code_attributes = otu_code_bucket.
        joins("LEFT OUTER JOIN otu_code_categories ON otu_code_categories.id = otu_codes.otu_code_category_id").
        select("DISTINCT people.grade, 
               CASE WHEN otu_code_category_id IS NULL THEN 
                'N/A' 
               ELSE 
                otu_code_categories.name 
               END as name,
               SUM(otu_codes.points) as amount").
        group("otu_code_category_id, people.grade, name").
        map(&:attributes)
      category_hash = Hash.new { |h,k| h[k] = [] }
      @teacher.school.grades.each do |grade|
        otu_code_attributes.each do |attribute_array|
          category_hash[grade[0]] << [attribute_array["name"], attribute_array["amount"].to_i] if attribute_array["grade"].to_s == grade[0].to_s
        end
      end
      category_hash
    end
  end
end
