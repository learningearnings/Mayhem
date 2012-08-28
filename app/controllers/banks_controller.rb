class BanksController < LoggedInController
  def show
    # FIXME: This is lame
    #@recent_checking_amounts = Plutus::Amount.where(account_id: current_person.primary_account).limit(20).joins(:transaction).order({ transaction: :created_at })
    if current_person.is_a? Student
      @recent_checking_amounts = PlutusAmountDecorator.decorate(Plutus::Amount.where(account_id: current_person.checking_account).limit(20).joins(:transaction).order({ transaction: :created_at }))
      @recent_savings_amounts  = PlutusAmountDecorator.decorate(Plutus::Amount.where(account_id: current_person.savings_account).limit(20).joins(:transaction).order({ transaction: :created_at }))
     else
        @recent_account_amounts = PlutusAmountDecorator.decorate(Plutus::Amount.where(account_id: current_person.primary_account)).limit(20).joins(:transaction).order({ transaction: :created_at }))
     end
  end

  def create_print_bucks
    @credit_manager = CreditManager.new
    @ones = params[:point1].to_i
    points1 = @ones
    @fives = params[:point5].to_i
    points5 = @fives * 5
    @tens = params[:point10].to_i
    points10 = @tens * 10
    if params[:teacher].present? && params[:teacher][:id].present?
      person = Teacher.find(params[:teacher][:id])
    else
      person = current_person
    end
    if person.main_account(person.schools.first).balance >= (points1 + points5 + points10)
      buck_params = {:person_school_link_id => person.person_school_links.first.id, :expires_at => (Time.now + 45.days) }
      bucks = []
      @ones.times do
        bucks << OtuCode.create(buck_params.merge :points => BigDecimal.new('1'))
      end
      @fives.times do
        bucks << OtuCode.create(buck_params.merge :points => BigDecimal.new('5'))
      end
      @tens.times do
        bucks << OtuCode.create(buck_params.merge :points => BigDecimal.new('10'))
      end
      bucks.map{|x| x.generate_code('AL')}
      points = bucks.map{|x| x.points}.sum
      @credit_manager.purchase_printed_bucks(person.schools.first, person, points)
      flash[:notice] = 'Bucks created!'
      redirect_to bank_path
    else
      flash[:error] = 'You do not have enough bucks.'
      render :show
    end
  end

  def create_ebucks
    @credit_manager = CreditManager.new
  end

end
