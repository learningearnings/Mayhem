# This class is used to create users in the system in bulk.
class BatchStudentCreator
  attr_reader :students, :school

  def initialize student_params,school=nil, student_class=Student
    @students       = []
    @student_params = student_params.dup
    @student_class  = student_class
    @school         = school
  end

  def call
    ActiveRecord::Base.transaction do
      @student_params.each do |student_param|
        classroom_id = student_param.delete(:classroom_id)
        user_params = student_param.delete(:user)
        student_param.merge! password_confirmation: student_param[:password]
        student = @student_class.new(student_param)
        user = Spree::User.new
        student.user = user
        user.update_attributes(user_params)
        user.save
        student.save
        if school
          psl = PersonSchoolLink.find_or_create_by_person_id_and_school_id(student.id, school.id)
          pscl = PersonSchoolClassroomLink.find_or_create_by_classroom_id_and_person_school_link_id(classroom_id, psl.id)
          pscl.activate
        end
        students << student
      end
      students.each do |student|
        raise ActiveRecord::Rollback unless student.valid? || student.user.valid?
      end
    end
    return false if students.select{|s| !s.valid? }.any?
    return true
  end
end
