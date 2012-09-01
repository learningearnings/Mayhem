# This is a class for managing our business logic regarding issuing credits (LE Bucks)
class CreditManager
  def initialize options={}
    @transaction_class = options[:transaction_class] || Plutus::Transaction
  end

  # TODO: What do we call this account?
  def main_account_name
    'MAIN_ACCOUNT'
  end

  # NOTE: I am confused about why debits and credits are switched here, but to make
  # my tests pass they needed to be.
  def transfer_credits description, from_account, to_account, amount
    transaction = @transaction_class.build({
      description: description,
      debits:      [{ account: to_account, amount: amount }],
      credits:     [{ account: from_account,   amount: amount }]
    })
    transaction.save
  end

  def issue_credits_to_school school, amount
    transfer_credits "Issue Credits to School", main_account_name, school.main_account_name, amount
  end

  def issue_store_credits_to_school school, amount
    transfer_credits "Issue Store Credits to School", main_account_name, school.store_account_name, amount
  end

  def revoke_store_credits_for_school school, amount
    transfer_credits "Revoke Store Credits from School", school.store_account_name, main_account_name, amount
  end

  def revoke_credits_for_school school, amount
    transfer_credits "Revoke Credits for School", school.main_account_name, main_account_name, amount
  end

  def purchase_printed_bucks school, teacher, amount
    transfer_credits "Teacher#{teacher.id} printed bucks", teacher.main_account_name(school), teacher.unredeemed_account_name(school), amount
   end

  def purchase_ebucks school, teacher, student, amount
    transfer_credits "Teacher#{teacher.id} ebucks for Student#{student.id}", teacher.main_account_name(school), teacher.undeposited_account_name(school), amount
   end

  def issue_credits_to_teacher school, teacher, amount
    transfer_credits "Issue Credits to Teacher", school.main_account_name, teacher.main_account_name(school), amount
  end

  def issue_print_credits_to_student school, teacher, student, amount
    transfer_credits "Issue Credits to Student", teacher.unredeemed_account_name(school), student.checking_account_name, amount
  end

  def issue_ecredits_to_student school, teacher, student, amount
    transfer_credits "Issue Credits to Student", teacher.undeposited_account_name(school), student.checking_account_name, amount
  end

  def transfer_credits_for_reward_purchase student, amount
    return false if student.balance < amount
    transfer_credits "Reward Purchase", student.checking_account_name, main_account_name, amount
  end

  def transfer_store_credits_for_wholesale_purchase school, amount
    return false if school.balance < amount
    transfer_credits "Wholesale Purchase", school.store_account_name, main_account_name, amount
  end

  def transfer_credits_from_checking_to_savings student, amount
    return false if student.checking_balance < amount
    transfer_credits "Transfer from Checking to Savings", student.checking_account_name, student.savings_account_name, amount
  end

  def transfer_credits_from_savings_to_checking student, amount
    return false if student.savings_balance < amount
    transfer_credits "Transfer from Savings to Checking", student.savings_account_name, student.checking_account_name, amount
  end
end
