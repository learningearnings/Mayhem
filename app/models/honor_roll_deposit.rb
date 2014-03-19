class HonorRollDeposit < ActiveRecord::Base

  attr_accessible :student_id, :amount, :school_id

  def student
    Student.find student_id
  end
end
