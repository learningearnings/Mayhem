require_relative 'active_model_command'
require_relative '../validators/positive_decimal_validator'

class StudentTransferCommand < ActiveModelCommand
  attr_accessor :amount, :direction, :student_id

  validates :direction, presence: true
  validates :student_id, presence: true, numericality: true
  validates_inclusion_of :direction, in: ["savings_to_checking", "checking_to_savings"]
  validates :amount, positive_decimal: true

  def initialize params={}
    @amount = BigDecimal(params[:amount]) if params[:amount]
    @direction = params[:direction]
    @student_id = params[:student_id]
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
