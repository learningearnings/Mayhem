class BanksController < LoggedInController
  def show
    # FIXME: This is lame
    #@recent_checking_amounts = Plutus::Amount.where(account_id: current_person.primary_account).limit(20).joins(:transaction).order({ transaction: :created_at })
    if current_person.is_a? Student
      @recent_checking_amounts = PlutusAmountDecorator.decorate(Plutus::Amount.where(account_id: current_person.checking_account).limit(20).joins(:transaction).order({ transaction: :created_at }))
      @recent_savings_amounts  = PlutusAmountDecorator.decorate(Plutus::Amount.where(account_id: current_person.savings_account).limit(20).joins(:transaction).order({ transaction: :created_at }))
    else
      @recent_account_amounts = PlutusAmountDecorator.decorate(Plutus::Amount.where(account_id: current_person.primary_account).limit(20).joins(:transaction).order({ transaction: :created_at }))
     end
  end

  def create_print_bucks
    @bank = Bank.new
    bucks = {:ones => params[:point1].to_i, :fives => params[:point5].to_i, :tens => params[:point10].to_i}
    if params[:teacher].present? && params[:teacher][:id].present?
      person = Teacher.find(params[:teacher][:id])
    else
      person = current_person
    end
    if person.main_account(person.schools.first).balance >= (bucks[:ones] + (bucks[:fives] * 5) + (bucks[:tens] * 10))
      @bank.create_print_bucks(person, 'AL', bucks)
      flash[:notice] = 'Bucks created!'
      redirect_to bank_path
    else
      flash[:error] = 'You do not have enough bucks.'
      render :show
    end
  end

  def create_ebucks
    @bank = Bank.new
    if current_person.main_account(current_person.schools.first).balance >= BigDecimal.new(params[:points])
      student = Student.find(params[:student][:id])
      @bank.create_ebucks(current_person, student, 'AL', params[:points])
      flash[:notice] = 'Bucks created!'
      redirect_to bank_path
    else
      flash[:error] = 'You do not have enough bucks.'
      render :show
    end
  end
end
