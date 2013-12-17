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
        next unless student_param["id"].present?
        classroom_id = student_param.delete("classroom_id")
        student = @student_class.find(student_param.delete("id"))
        user_param = student_param["user"]
        if classroom_id
          psl = PersonSchoolLink.find_or_create_by_person_id_and_school_id(student.id, @school["school"]["id"])
          pscl = PersonSchoolClassroomLink.find_or_create_by_classroom_id_and_person_school_link_id(classroom_id, psl.id)
          pscl.activate
        end
        responses << student.update_attributes(first_name: student_param["first_name"],
                                              last_name: student_param["last_name"],
                                              gender: student_param["gender"],
                                              grade: student_param["grade"])
        responses << student.user.update_attributes(username: user_param["username"],
                                                    password: user_param["password"],
                                                    password_confirmation: user_param["password"])
        students << student
      end
      unless responses.select{|r| r == false}.empty?
        success = false
        raise ActiveRecord::Rollback
      end
    end
    return success
  end

  def delete!
    ActiveRecord::Base.transaction do
      responses = []
      @student_params.each do |student_param|
        student = @student_class.find(student_param.delete("id"))
        psl = PersonSchoolLink.find_or_create_by_person_id_and_school_id(student.id, @school["school"]["id"])
        psl.deactivate!
      end
    end
    true
  end
end
