# This is a class for managing our business logic regarding issuing credits (LE Bucks)
class CreditManager
  def initialize options={}
    @transaction_class = options[:transaction_class] || Plutus::Transaction
  end

  # TODO: What do we call this account?
  def main_account_name
    'MAIN_ACCOUNT'
  end

  def transfer_credits from_account, to_account, amount
    transaction = @transaction_class.build({
      description: "Credit Transfer",
      debits:      [{ account: from_account, amount: amount }],
      credits:     [{ account: to_account,   amount: amount }]
    })
    transaction.save
  end

  def issue_credits_to_school school, amount
    transfer_credits main_account_name, school.account_name, amount
  end

  def revoke_credits_for_school school, amount
    transfer_credits school.account_name, main_account_name, amount
  end
end
