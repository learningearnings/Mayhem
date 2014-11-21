# This class is used to create users in the system in bulk.
class BatchTeacherCreator
  attr_reader :teachers, :school

  def initialize teacher_params,school=nil, teacher_class=Teacher
    @teachers       = []
    @teacher_params = teacher_params.dup
    @teacher_class  = teacher_class
    @school         = school
  end

  def call
    ActiveRecord::Base.transaction do
      @teacher_params.each do |teacher_param|
        user_params = teacher_param.delete(:user)
        teacher_param.merge! password_confirmation: teacher_param[:password]
        teacher = @teacher_class.new(teacher_param)
        user = Spree::User.new
        teacher.user = user
        user.update_attributes(user_params)
        user.save
        teacher.save
        user.update_attributes(user_params)
        if school
          psl = PersonSchoolLink.find_or_create_by_person_id_and_school_id(teacher.id, school.id)
        end
        teachers << teacher
      end
      teachers.each do |teacher|
        raise ActiveRecord::Rollback unless teacher.valid? || teacher.user.valid?
      end
    end
    return false if teachers.select{|s| !s.valid? }.any?
    return true
  end
end
