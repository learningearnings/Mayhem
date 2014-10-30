class BanksController < LoggedInController
  before_filter :load_recent_bucks, only: [:show]
  before_filter :load_unredeemed_bucks, only: [:show]
  before_filter :load_reward_highlights, only: [:show]

  def show
  end

  def code_lookup
    @looked_up_code = OtuCode.for_school(current_school).where(code: params[:code]).first
    render :partial => "code_lookup"
  end

  def redeem_bucks
    person = Student.find_by_id(params[:student_id]) if params[:student_id]
    person = current_person unless person

    if person.code_entry_failures.within_five_minutes.count >= 8
      flash[:error] = 'You have entered too many incorrect codes. Please try again in 5 minutes'
      redirect_to bank_path and return
    end

    otu_code = current_person.otu_codes.where(code: params[:code].upcase) if params[:code]
    if otu_code.present?
      if otu_code.active? && !otu_code.expired?
        @bank = Bank.new
        @bank.claim_bucks(person, otu_code)
        flash[:notice] = 'Credits claimed!'
        person.code_entry_failures.destroy_all
      else
        flash[:error] = 'You already deposited this credit into your account.'
        person.code_entry_failures.create
      end
    else
      flash[:error] = 'This credit is not valid. Please verify you entered it correctly.'
      person.code_entry_failures.create
    end
    clear_balance_cache!
    redirect_to bank_path
  end

  def checking_transactions
    recent_checking_amounts = PlutusAmountDecorator.decorate(Plutus::Amount.where(account_id: current_person.checking_account).joins(:transaction).order({ transaction: :created_at}).reverse_order.page(params[:page]).per(5))
    render partial: 'checking_ledger_table', locals: { amounts: recent_checking_amounts }
  end

  def savings_transactions
    recent_savings_amounts  = PlutusAmountDecorator.decorate(Plutus::Amount.where(account_id: current_person.savings_account).joins(:transaction).order({ transaction: :created_at }).reverse_order.page(params[:page]).per(5))
    render partial: 'savings_ledger_table', locals: { amounts: recent_savings_amounts }
  end

  protected
  def load_recent_bucks
    @recent_checking_amounts = PlutusAmountDecorator.decorate(Plutus::Amount.where(account_id: current_person.checking_account).joins(:transaction).order({ transaction: :created_at }).reverse_order.page(1).per(5))
    @recent_savings_amounts  = PlutusAmountDecorator.decorate(Plutus::Amount.where(account_id: current_person.savings_account).joins(:transaction).order({ transaction: :created_at }).reverse_order.page(1).per(5))
  end

  def load_unredeemed_bucks
    @unredeemed_bucks = current_person.otu_codes.active
  end

  def load_reward_highlights
    @products = get_reward_highlights
  end
end
