# This class is used to updater teachers in the system in bulk.
class BatchTeacherUpdater
  attr_reader :teachers, :school

  def initialize teacher_params, school, teacher_class=Teacher
    @teachers       = []
    @school         = school
    @teacher_params = teacher_params.dup
    @teacher_class  = teacher_class
  end

  def call
    success = true
    ActiveRecord::Base.transaction do
      responses = []
      @teacher_params.each do |teacher_param|
        next unless teacher_param["id"].present?
        teacher = @teacher_class.find(teacher_param.delete("id"))
        user_param = teacher_param["user"]
        responses << teacher.update_attributes(first_name: teacher_param["first_name"],
                                              last_name: teacher_param["last_name"],
                                              gender: teacher_param["gender"],
                                              grade: teacher_param["grade"])
        responses << teacher.user.update_attributes(username: user_param["username"],
                                                    password: user_param["password"],
                                                    email: user_param["email"],
                                                    password_confirmation: user_param["password"])
        teachers << teacher
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
      @teacher_params.each do |teacher_param|
        teacher = @teacher_class.find(teacher_param.delete("id"))
        psl = PersonSchoolLink.find_or_create_by_person_id_and_school_id(teacher.id, @school["school"]["id"])
        psl.deactivate!
      end
    end
    true
  end

  def add_credit
    
  end

  def remove_credit
    
  end
end
