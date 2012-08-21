class StudentTransferCommand
  include ActiveModel::Validations
  include ActiveModel::Naming
  include ActiveModel::Conversion

  attr_accessor :amount, :direction, :student_id

  validates :direction, presence: true
  validates :student_id, presence: true, numericality: true
  validates_inclusion_of :direction, in: ["savings_to_checking", "checking_to_savings"]
  validates :amount, positive_decimal: true

  # This is so that activemodel acts like we want in the form
  def persisted?
    false
  end

  # The transfer knows what to call on credit manager based on its direction
  def transfer_method
    case direction
    when "savings_to_checking"
      :transfer_credits_from_savings_to_checking
    when "checking_to_savings"
      :transfer_credits_from_checking_to_savings
    else
      raise "unknown direction"
    end
  end

  def student
    Student.find(student_id)
  end

  def credit_manager
    CreditManager.new
  end

  def execute!
    credit_manager.send(transfer_method, student, amount)
  end
end
