# This is a class for managing our business logic regarding issuing credits (LE Bucks)
class CreditManager
  def initialize options={}
    @transaction_class = options[:transaction_class] || Plutus::Transaction
    @account_class = options[:account_class] || Plutus::Account
    @le_main_account = nil
    @le_game_account = nil
    @transaction_time_stamp = nil
  end

  def transaction_time_stamp=(timestamp)
    @transaction_time_stamp = timestamp
  end

  # TODO: What do we call this account?
  def main_account_name
    'MAIN_ACCOUNT'
  end

  def main_account
    @le_main_account ||= @account_class.find_by_name(main_account_name)
  end

  def game_account_name
    'GAME_ACCOUNT'
  end

  def game_account
    @le_game_account ||= @account_class.find_by_name(game_account_name)
  end

  # NOTE: I am confused about why debits and credits are switched here, but to make
  # my tests pass they needed to be.
  def transfer_credits description, from_account, to_account, amount, buck_batch=nil
    transaction = @transaction_class.build({
      description: description,
      commercial_document: buck_batch,
      created_at: @transaction_time_stamp,
      debits:      [{ account: to_account, amount: amount }],
      credits:     [{ account: from_account,   amount: amount }]
    })
    transaction.save
    transaction
  end

  def issue_credits_to_school school, amount
    transfer_credits "Issue Credits to School", main_account, school.main_account, amount
  end

  def issue_store_credits_to_school school, amount
    transfer_credits "Issue Store Credits to School", main_account, school.store_account, amount
  end

  def revoke_store_credits_for_school school, amount
    transfer_credits "Revoke Store Credits from School", school.store_account, main_account, amount
  end

  def revoke_credits_for_school school, amount
    transfer_credits "Revoke Credits for School", school.main_account, main_account, amount
  end

  def purchase_printed_bucks school, teacher, amount, buck_batch=nil
    transfer_credits "Teacher#{teacher.id} printed bucks", teacher.main_account(school), teacher.unredeemed_account(school), amount, buck_batch
   end

  def purchase_ebucks school, teacher, student, amount
    transfer_credits "Teacher#{teacher.id} ebucks for Student#{student.id}", teacher.main_account(school), teacher.undeposited_account(school), amount
   end

  def transfer_credits_to_teacher school, from_teacher, to_teacher, amount
    transfer_credits "Transfer Credits to Teacher", from_teacher.main_account(school), to_teacher.main_account(school), amount
  end

  def issue_credits_to_teacher school, teacher, amount
    transfer_credits "Issue Credits to Teacher", school.main_account, teacher.main_account(school), amount
  end

  def issue_credits_to_student school, teacher, student, amount
    transfer_credits "Issue Credits to Student", teacher.unredeemed_account(school), student.checking_account, amount
  end

  def issue_print_credits_to_student school, teacher, student, amount
    transfer_credits "Issue Credits to Student", teacher.unredeemed_account(school), student.checking_account, amount
  end

  def issue_ecredits_to_student school, teacher, student, amount
    transfer_credits "Issue Credits to Student", teacher.undeposited_account(school), student.checking_account, amount
  end

  def issue_admin_credits_to_student student, amount
    transfer_credits "Credits issued by LearningEarnings Administrator", main_account, student.checking_account, amount
  end

  def issue_game_credits_to_student game_string, student, amount
    transfer_credits "Credits Earned for #{game_string}", game_account, student.checking_account, amount
  end

  def transfer_credits_for_local_purchase student, teacher, amount
    return false if student.balance < amount
    transfer_credits "Reward Purchase", student.checking_account, teacher.main_account(student.school), amount
  end

  def transfer_credits_for_reward_purchase student, amount
    return false if student.balance < amount
    transfer_credits "Reward Purchase", student.checking_account, main_account, amount
  end

  def transfer_store_credits_for_wholesale_purchase school, amount
    return false if school.store_account.balance < amount
    transfer_credits "Wholesale Purchase", school.store_account, main_account, amount
  end

  def transfer_credits_from_checking_to_savings student, amount
    return false if student.checking_balance < amount
    transfer_credits "Transfer from Checking to Savings", student.checking_account, student.savings_account, amount
  end

  def transfer_credits_from_savings_to_checking student, amount
    return false if student.savings_balance < amount
    transfer_credits "Transfer from Savings to Checking", student.savings_account, student.checking_account, amount
  end

  def transfer_credits_from_checking_to_hold student, amount
    return false if student.checking_balance < amount
    transfer_credits "Transfer from Checking to Hold", student.checking_account, student.hold_account, amount
  end

  def transfer_credits_from_hold_to_checking student, amount
    return false if student.hold_balance < amount
    transfer_credits "Transfer from Hold to Checking", student.hold_account, student.checking_account, amount
  end
end
