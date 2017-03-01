class Mobile::V1::Teachers::BankController < Mobile::V1::Teachers::BaseController
  include Mixins::Banks
  def award_credits
    #logger.debug("AKT bank->award_credits")
    logger.debug(params.inspect)
    if params[:students].blank? || params[:credits].blank? || params[:students].size == 0 || params[:credits].size == 0
      logger.error "Mobile::V1::Teachers::BankController.award_credits: Must supply students and credits"
      render json: { status: :unprocessible_entity } and return
    end

    @student_ids = params[:students].collect { | student | student[:id] }
    @students = Student.where(id: @student_ids)

    @category_ids = params[:credits].collect { | student | student[:id] }
    get_buck_batches
    get_bank
    # Override on_success and on_failure
    @failed = false # Not thrilled with this...
    @bank.on_success = lambda{ |x| return true }
    @bank.on_failure = lambda{ @failed = true }
    OtuCode.transaction do
      @students.each do | student |
        params[:credits].each do | credit |
          student_credits = SanitizingBigDecimal(credit[:credit_quantity].to_s)
          category_id = credit[:id]
          if student_credits > 0.0
            logger.debug("Awarding #{student_credits} of credit #{category_id} to student #{student.id}") 
            issue_ebucks_to_student(student, student_credits, category_id) 
          else
            logger.error("Bank > award_credits, no credit quantity specified #{params.inspect}") 
            render json: { error: 'No credit quantity specified' }, status: :unprocessible_entity and return 
          end
        end
      end
      if @failed
        ActiveRecord::Rollback
        logger.error "Mobile::V1::Teachers::BankController.create_ebucks_for_students: Database Error"
        render json: { status: :unprocessible_entity } and return
      else
        render json: { status: :ok } and return
      end
    end
  end

  def on_success(obj = nil)
    return true
  end

  def on_failure
    @failed = true
  end
  
protected
  def person
    current_person
  end

end
