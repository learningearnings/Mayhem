# This class is used to updater teachers in the system in bulk.
class TeacherCreditUpdater
  attr_reader :teachers, :school

  def initialize school,teacher_params, credit_amount, teacher_class=Teacher, credit_manager=CreditManager.new
    @teachers       = []
    @school         = school
    @teacher_params = teacher_params.dup
    @teacher_class  = teacher_class
    @credit_amount = credit_amount
    @credit_manager = credit_manager

  end

  def add_credit
    @teacher_params.each do |id|
      next unless id.present?
      teacher = Teacher.find(id)
      @credit_manager.monthly_credits_to_teacher current_school, teacher, amount_for_teacher
      teacher_credit = TeacherCredit.new(teacher_id: teacher.id, school_id: @school.id, teacher_name: teacher.name, district_guid: @school.district_guid, amount: @credit_amount, credit_source: "ADMIN", reason: "Issue Monthly Credits")
      teacher_credit.save
    end
  end

  def remove_credit
    @teacher_params.each do |id|
      next unless id.present?
      teacher = Teacher.find(id)
      CreditManager.new.remove_credit_from_teacher current_school, teacher, amount_for_teacher
      teacher_credit = TeacherCredit.new(teacher_id: teacher.id, school_id: @school.id, teacher_name: teacher.name, district_guid: @school.district_guid, amount: @credit_amount, credit_source: "ADMIN", reason: "Remove Credits")
      teacher_credit.save
    end
  end  
end
