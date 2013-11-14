# This class is used to updater students in the system in bulk.
class BatchStudentUpdater
  attr_reader :students, :school

  def initialize student_params, school, student_class=Student
    @students       = []
    @school         = school
    @student_params = student_params.dup
    @student_class  = student_class
  end

  def call
    success = true
    ActiveRecord::Base.transaction do
      responses = []
      @student_params.each do |student_param|
        student = @student_class.find(student_param.delete(:id))
        user_param = student_param.delete(:user)
        responses << student.update_attributes(student_param)
        responses << student.user.update_attributes(user_param)
        students << student
      end
      unless responses.select{|r| r == false}.empty?
        success = false
        raise ActiveRecord::Rollback
      end
    end
    return success
  end
end
