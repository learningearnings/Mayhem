class BanksController < LoggedInController
  def show
    # FIXME: This is lame
    recent_credit_amounts = current_person.account.credit_amounts.limit(10)
    recent_debit_amounts = current_person.account.debit_amounts.limit(10)
    @recent_checking_amounts = recent_credit_amounts + recent_debit_amounts
    @recent_checking_amounts.sort!{|a| a.created_at }
  end
end
