class HonorRollDeposit < ActiveRecord::Base
  def student
    Student.find student_id
  end
end
