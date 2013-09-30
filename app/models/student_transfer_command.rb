require_relative 'active_model_command'
require_relative '../validators/positive_decimal_validator'

class StudentTransferCommand < ActiveModelCommand
  attr_accessor :amount, :direction, :student_id, :on_success, :on_failure

  validates :direction, presence: true
  validates :student_id, presence: true, numericality: true
  validates_inclusion_of :direction, in: ["savings_to_checking", "checking_to_savings"]
  validates :amount, positive_decimal: true

  def initialize params={}
    @amount = get_decimal(params[:amount]) if params[:amount]
    @direction = params[:direction]
    @student_id = params[:student_id]
    @on_success = lambda{}
    @on_failure = lambda{}
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
    if amount > 0
      success = credit_manager.send(transfer_method, student, amount)
      if success
        on_success.call()
      else
        on_failure.call()
      end
    else
      on_failure.call()
    end
  end

  def get_decimal(amount_string)
    coerced_amount = amount_string.gsub('$', '').gsub(',', '')
    BigDecimal(coerced_amount)
  end
end
