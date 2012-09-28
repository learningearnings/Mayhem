class BanksController < LoggedInController
  before_filter :load_recent_bucks, only: [:show, :redeem_bucks]
  before_filter :load_unredeemed_bucks, only: [:show, :redeem_bucks]

  def show
    with_filters_params = params
    with_filters_params[:filters] = session[:filters] || [1]
    @searcher = Spree::Config.searcher_class.new(with_filters_params)
    @products = @searcher.retrieve_products
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

  def checking_transactions
    recent_checking_amounts = PlutusAmountDecorator.decorate(Plutus::Amount.where(account_id: current_person.checking_account).joins(:transaction).order({ transaction: :created_at }).page(params[:page]).per(10))
    render partial: 'ledger_table', locals: { amounts: recent_checking_amounts }
  end

  def savings_transactions
    recent_savings_amounts  = PlutusAmountDecorator.decorate(Plutus::Amount.where(account_id: current_person.savings_account).joins(:transaction).order({ transaction: :created_at }).page(params[:page]).per(10))
    render partial: 'ledger_table', locals: { amounts: recent_savings_amounts }
  end

  protected
  def load_recent_bucks
    @recent_checking_amounts = PlutusAmountDecorator.decorate(Plutus::Amount.where(account_id: current_person.checking_account).joins(:transaction).order({ transaction: :created_at }).page(1).per(10))
    @recent_savings_amounts  = PlutusAmountDecorator.decorate(Plutus::Amount.where(account_id: current_person.savings_account).joins(:transaction).order({ transaction: :created_at }).page(1).per(10))
  end

  def load_unredeemed_bucks
    @unredeemed_bucks = current_person.otu_codes.active
  end
end
