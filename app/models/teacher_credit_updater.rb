# This class is used to updater teachers in the system in bulk.
class TeacherCreditUpdater
  attr_reader :teachers, :school

  def initialize school,teacher_params, credit_amount, action, teacher_class=Teacher, credit_manager=CreditManager.new
    @teachers       = []
    @school         = school
    @teacher_params = teacher_params.dup
    @teacher_class  = teacher_class
    @credit_amount = credit_amount
    @credit_manager = credit_manager
    @update_action = action

  end

  def handle_credits_to_teacher
    @teacher_params.each do |id|
      next unless id.present?
      teacher = Teacher.find(id)
      if @update_action == "Add Credits"
        add_credit(teacher)
      else
        remove_credit(teacher)
      end  
    end
  end

  def add_credit(teacher)
    @credit_manager.monthly_credits_to_teacher @school, teacher, @credit_amount
    teacher_credit = TeacherCredit.new(teacher_id: teacher.id, school_id: @school.id, teacher_name: teacher.name, district_guid: @school.district_guid, amount: @credit_amount, credit_source: "ADMIN", reason: "Issue Monthly Credits")
    teacher_credit.save
  end

  def remove_credit(teacher)
    @credit_manager.remove_credit_from_teacher @school, teacher, @credit_amount
    teacher_credit = TeacherCredit.new(teacher_id: teacher.id, school_id: @school.id, teacher_name: teacher.name, district_guid: @school.district_guid, amount: @credit_amount, credit_source: "ADMIN", reason: "Remove Credits")
    teacher_credit.save
  end  
end
