class BanksController < LoggedInController
  before_filter :load_recent_bucks, only: [:show, :redeem_bucks]
  before_filter :load_unredeemed_bucks, only: [:show, :redeem_bucks]
  before_filter :load_reward_highlights, only: [:show, :redeem_bucks]

  def show
  end

  def redeem_bucks
    person = Student.find_by_id(params[:student_id]) if params[:student_id]
    person = current_person unless person

    otu_code = OtuCode.find_by_code(params[:code])
    if otu_code.present?
      if otu_code.active? && !otu_code.expired?
        @bank = Bank.new
        @bank.claim_bucks(person, otu_code)
        flash[:notice] = 'Credits claimed!'
      elsif otu_code.student.present? && otu_code.student == current_person
        flash[:error] = 'You already deposited this credit into your account.'
      elsif otu_code.student.present?
        flash[:error] = 'This credit was deposited by another user already'
      end
    else
      flash[:error] = 'This credit is not valid. Please verify you entered it correctly.'
    end
    redirect_to bank_path
  end

  def checking_transactions
    recent_checking_amounts = PlutusAmountDecorator.decorate(Plutus::Amount.where(account_id: current_person.checking_account).joins(:transaction).order({ transaction: :created_at}).reverse_order.page(params[:page]).per(10))
    render partial: 'checking_ledger_table', locals: { amounts: recent_checking_amounts }
  end

  def savings_transactions
    recent_savings_amounts  = PlutusAmountDecorator.decorate(Plutus::Amount.where(account_id: current_person.savings_account).joins(:transaction).order({ transaction: :created_at }).reverse_order.page(params[:page]).per(10))
    render partial: 'savings_ledger_table', locals: { amounts: recent_savings_amounts }
  end

  protected
  def load_recent_bucks
    @recent_checking_amounts = PlutusAmountDecorator.decorate(Plutus::Amount.where(account_id: current_person.checking_account).joins(:transaction).order({ transaction: :created_at }).reverse_order.page(1).per(10))
    @recent_savings_amounts  = PlutusAmountDecorator.decorate(Plutus::Amount.where(account_id: current_person.savings_account).joins(:transaction).order({ transaction: :created_at }).reverse_order.page(1).per(10))
  end

  def load_unredeemed_bucks
    @unredeemed_bucks = current_person.otu_codes.active
  end

  def load_reward_highlights
    @products = get_reward_highlights
  end
end
