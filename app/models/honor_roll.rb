class HonorRoll
  attr_reader :school, :start_date, :end_date

  def initialize(school, start_date=(Date.today - 7.days), end_date=Date.today)
    @school = school
    @start_date = start_date
    @end_date = end_date
  end

  def charity_purchases_per_person(count=3)
    {}.tap do |output|
      charity_purchases_per_account(count).each do |key, value|
        person = Plutus::Account.find(key).person_account_link.person
        output[person] = value
      end
    end
  end

  def deposits_per_person(count=3)
    {}.tap do |output|
      deposits_per_account(count).each do |key, value|
        link = Plutus::Account.find(key).person_account_link
        if link.present? && link.person.present?
          output[link.person] = value
        end
      end
    end
  end

  #private
  def charity_purchases
    transactions_in_time_range
      .with_spree_products
      .for_accounts(accounts_in_school)
      .merge(Spree::Product.with_property_value('reward_type','charity'))
  end

  def deposit_transactions
    transactions_in_time_range.joins(:amounts => {:account => {:person_account_link => {:person => :person_school_links}}}).where("person_school_links.school_id = ?", @school.id)
  end

  def deposit_transactions_for_students
    deposit_transactions.where('people.type = ?', 'Student')
  end

  def most_deposited_credits
    deposit_transactions_for_students.where("description NOT IN (?)", ['Transfer from Checking to Savings', 'Transfer from Savings to Checking', "Reward Refund"])
  end
  
  def transactions_in_time_range
    Plutus::Transaction.with_main_account.order('plutus_transactions.created_at desc').where('plutus_transactions.created_at BETWEEN ? AND ?', start_date, end_date)
  end

  def deposits_per_account(count)
    hash_as_key_value_array = Hash.new(BigDecimal('0.0')).tap do |output|
      most_deposited_credits.each do |transaction|
        amount = credit_amount_on(transaction)
        account_id = amount.account_id
        account = Plutus::Account.includes(:person_account_link => :person).find(account_id)
        next unless account.person_account_link.present?
        next if account.person_account_link.person.is_a?(Teacher) || account.person_account_link.person.is_a?(SchoolAdmin)
        output[account_id] = output[account_id] + amount.amount
      end
    end.sort_by{|key, value| value}.reverse
    hash_as_key_value_array = hash_as_key_value_array.take(count)
    hash_from_key_value_array(hash_as_key_value_array)
  end

  def charity_purchases_per_account(count)
    hash_as_key_value_array = Hash.new(BigDecimal('0.0')).tap do |output|
      charity_purchases.each do |transaction|
        amount = credit_amount_on(transaction)
        account_id = amount.account_id
        output[account_id] = output[account_id] + amount.amount
      end
    end.sort_by{|key, value| value}.reverse
    hash_as_key_value_array = hash_as_key_value_array.take(count)
    hash_from_key_value_array(hash_as_key_value_array)
  end

  protected
  def credit_amount_on(transaction)
    transaction.credit_amounts.first
  end

  def hash_from_key_value_array(array)
    array.inject({}) do |hash, value|
      hash[value.first] = value.last
      hash
    end
  end

  def accounts_in_school
    PersonAccountLink.includes(:account).for_school(school).map(&:account)
  end
end
