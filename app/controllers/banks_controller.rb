class BanksController < LoggedInController
  def show
    # FIXME: This is lame
    @recent_checking_amounts = PlutusAmountDecorator.decorate(Plutus::Amount.where(account_id: current_person.checking_account).limit(20).joins(:transaction).order({ transaction: :created_at }))
    @recent_savings_amounts  = PlutusAmountDecorator.decorate(Plutus::Amount.where(account_id: current_person.savings_account).limit(20).joins(:transaction).order({ transaction: :created_at }))
  end
end
