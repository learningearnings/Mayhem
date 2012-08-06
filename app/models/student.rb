class Student < Person
  after_create :ensure_account

  def school
    schools.where("person_school_links.status = 'active'").order('created_at desc').first
  end

  # FIXME: The account creation on various models needs to be extracted to a module.  #account_name should be all we have to define.
  def account_name
    "STUDENT#{id}"
  end

  def account
    Plutus::Asset.find_by_name account_name
  end

  def balance
    account.balance
  end

  private
  def ensure_account
    account || Plutus::Asset.create(name: account_name)
  end

end
