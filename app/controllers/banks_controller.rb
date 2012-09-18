class BanksController < LoggedInController
  def show
    @recent_checking_amounts = PlutusAmountDecorator.decorate(Plutus::Amount.where(account_id: current_person.checking_account).limit(20).joins(:transaction).order({ transaction: :created_at }))
    @recent_savings_amounts  = PlutusAmountDecorator.decorate(Plutus::Amount.where(account_id: current_person.savings_account).limit(20).joins(:transaction).order({ transaction: :created_at }))

    @unredeemed_bucks = current_person.otu_codes.active
  end

  def redeem_bucks
    person = Student.find_by_id(params[:student_id]) if params[:student_id]
    person = current_person unless person
      
    if otu_code = OtuCode.active.find_by_code(params[:code])
      if !otu_code.expired?
        @bank = Bank.new
        @bank.claim_bucks(person, otu_code)
        flash[:notice] = 'Bucks claimed!'
        redirect_to bank_path
      else
        flash[:error] = 'Code Expired.'
        redirect_to bank_path
      end
    else
      flash[:error] = 'Invalid Code.'
      render :show
    end
  end
end
