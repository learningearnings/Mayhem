class Student < Person
  before_save :check_coppa
  after_create :ensure_account
  validates_presence_of :grade
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
  private

  def check_coppa
    if self.grade <= 6
      self.last_name = self.last_name[0]
    end
  end

end
