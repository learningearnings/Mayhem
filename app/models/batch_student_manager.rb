# This class is used to create and update users in the system in bulk.
class BatchStudentManager
  attr_reader :students

  def initialize student_params, student_class=Student
    @students = []
    @student_params = student_params
    @student_class = student_class
  end

  def call
    @student_params.each do |student_param|
      student = @student_class.new(student_param)
      student.save
      students << student
    end
    return students.select{|s| !s.valid? }.any?
  end
end
