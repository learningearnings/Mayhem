require 'draper'

class PersonDecorator < Draper::Base
  decorates :person

  def checking_balance
    person.checking_account.balance
  end

  def savings_balance
    person.savings_account.balance
  end
end
