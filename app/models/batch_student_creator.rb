# This class is used to create users in the system in bulk.
class BatchStudentCreator
  attr_reader :students

  def initialize student_params, student_class=Student
    @students = []
    @student_params = student_params
    @student_class = student_class
  end

  def call
    ActiveRecord::Base.transaction do
      @student_params.each do |student_param|
        student = @student_class.new(student_param)
        student.save
        students << student
        raise ActiveRecord::Rollback unless student.valid?
      end
    end
    return false if students.select{|s| !s.valid? }.any?
    return true
  end
end
