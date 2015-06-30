class Mobile::V1::Students::BankController < Mobile::V1::Students::BaseController
  
  def redeem_bucks
 
    # scoping by student_id of [id, nil] is because ecredits have an id associated, but printed credits don't
    otu_code = OtuCode.where(code: params[:code].upcase, student_id: [current_person.id, nil], redeemed_at: nil).first if params[:code]
    if otu_code.present?
      if otu_code.active? && !otu_code.expired?
        @bank = Bank.new
        @bank.claim_bucks(current_person, otu_code)
        @msg = 'Credits claimed!'
        MixPanelTrackerWorker.perform_async(current_user.id, 'Enter Credit Code')
        current_person.code_entry_failures.destroy_all
        render json: { status: :ok, msg: @msg } 
      else
        @msg = 'You already deposited this credit into your account.'
        current_person.code_entry_failures.create
        render json: { status: :unprocessible_entity, msg: @msg }         
      end
    else
      @msg = 'This credit is not valid. Please verify you entered it correctly.'
      current_person.code_entry_failures.create
      render json: { status: :unprocessible_entity, msg: @msg }       
    end

  end
  
end
