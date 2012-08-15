class Teacher < Person

  has_many :schools, :through => :person_school_links
  validates_presence_of :grade

  # FIXME: The account creation on various models needs to be extracted to a module.  #account_name should be all we have to define.
  def main_account_name
    "TEACHER#{id} MAIN"
  end

  def unredeemed_account_name
    "TEACHER#{id} UNREDEEMED"
  end

  def undeposited_account_name
    "TEACHER#{id} UNDEPOSITED"
  end

  def main_account
    Plutus::Asset.find_by_name main_account_name
  end

  def unredeemed_account
    Plutus::Asset.find_by_name unredeemed_account_name
  end

  def undeposited_account
    Plutus::Asset.find_by_name undeposited_account_name
  end

  def accounts
    Plutus::Account.where "name LIKE '%TEACHER#{id}%'"
  end

  def balance
    main_account.balance
  end

  def name
    first_name + ' ' + last_name
  end

  def setup_accounts(school)
    main_account || Plutus::Asset.create(name: (main_account_name + " SCHOOL#{school.id}"))
    unredeemed_account || Plutus::Asset.create(name: (unredeemed_account_name + " SCHOOL#{school.id}"))
    undeposited_account || Plutus::Asset.create(name: (undeposited_account_name + " SCHOOL#{school.id}"))
  end
end
