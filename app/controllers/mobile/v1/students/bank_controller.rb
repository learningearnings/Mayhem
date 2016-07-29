class Mobile::V1::Students::BankController < Mobile::V1::Students::BaseController
  
  def redeem_bucks
 
    # scoping by student_id of [id, nil] is because ecredits have an id associated, but printed credits don't
    otu_code = OtuCode.where(code: params[:code].upcase, student_id: [current_person.id, nil]).first if params[:code]
    if otu_code.present?
      if !otu_code.redeemed_at.blank?
          @msg = 'Your code has already been deposited'       
          render json: { status: :unprocessible_entity, msg: @msg }    and return      
      end
      if otu_code.active? && !otu_code.expired?
        @bank = Bank.new
        @bank.claim_bucks(current_person, otu_code)
        @msg = 'Credits claimed!'
        MixPanelTrackerWorker.perform_async(current_user.id, 'Enter Credit Code')
        current_person.code_entry_failures.destroy_all
        render json: { status: :ok, msg: @msg } 
      else
        @msg = 'Your code is expired'
        current_person.code_entry_failures.create
        render json: { status: :unprocessible_entity, msg: @msg }         
      end
    else
      @msg = 'Your code is not valid. Please try again.'
      current_person.code_entry_failures.create
      render json: { status: :unprocessible_entity, msg: @msg }       
    end

  end
  
  def transfer_credits
    if params[:amount].blank? or params[:direction].blank? or params[:student_id].blank?
      @msg = "Missing required parameters ( amount, direction, student_id)"
      render json: { status: :unprocessible_entity, msg: @msg} and return
    end
    @amount = get_decimal(params[:amount])
    if @amount <= 0
      @msg = "Amount must be >= 0"
      render json: { status: :unprocessible_entity, msg: @msg} and return      
    end
    @direction = params[:direction]
    @student_id = params[:student_id]   
    @student = Student.find(@student_id)
    if !@student
      @msg = "Student not found"
      render json: { status: :unprocessible_entity, msg: @msg } and return      
    end
     
    cm = CreditManager.new
    if @direction == "savings_to_checking"
      if cm.transfer_credits_from_savings_to_checking(@student, @amount)
        @msg = "Succesfully transfered credits from savings to checking"
        render json: { status: :ok, msg: @msg }
      else
        @msg = "Insufficient funds"
        render json: { status: :unprocessible_entity, msg: @msg }
      end
    else
      if cm.transfer_credits_from_checking_to_savings(@student, @amount)
        @msg = "Succesfully transfered credits from checking to savings"
        render json: { status: :ok, msg: @msg }
      else
        @msg = "Insufficient funds"
        render json: { status: :unprocessible_entity, msg: @msg }
      end      
    end
  end
  
  def get_decimal(amount_string)
    #coerced_amount = amount_string.gsub('$', '').gsub(',', '')
    BigDecimal(amount_string)
  end
  
end
