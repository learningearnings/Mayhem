class Student < Person
  before_save :check_coppa
  after_create :ensure_accounts
  validates_presence_of :grade

  has_many :schools, :through => :person_school_links

  def school
    schools.where("person_school_links.status = 'active'").order('created_at desc').first
  end
  
  def name
    first_name + ' ' + last_name
  end

  # FIXME: The account creation on various models needs to be extracted to a module.  #account_name should be all we have to define.
  def checking_account_name
    "STUDENT#{id} CHECKING"
  end

  def savings_account_name
    "STUDENT#{id} SAVINGS"
  end

  def checking_account
    Plutus::Asset.find_by_name checking_account_name
  end

  def savings_account
    Plutus::Asset.find_by_name savings_account_name
  end

  def balance
    checking_account.balance
  end

  def checking_balance
    checking_account.balance
  end

  def savings_balance
    savings_account.balance
  end

  private
  def ensure_accounts
    checking_account || Plutus::Asset.create(name: checking_account_name)
    savings_account || Plutus::Asset.create(name: savings_account_name)
  end

  def check_coppa
    if self.grade <= 6
      self.last_name = self.last_name[0]
    end
  end
end
