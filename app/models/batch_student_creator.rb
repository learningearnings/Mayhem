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
        user_params = student_param.delete(:user)
        student_param.merge! password_confirmation: student_param[:password]
        student = @student_class.new(student_param)
        user = Spree::User.new
        student.user = user
        user.update_attributes(user_params)
        user.save
        student.save
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
