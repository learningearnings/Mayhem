class Student < Person
  before_save :check_coppa
  after_create :ensure_accounts
  after_create :create_user
  validates_presence_of :grade

  has_many :otu_codes
  has_one :locker, foreign_key: :person_id

  attr_accessor :username, :password, :password_confirmation, :email
  attr_accessible :username, :password, :password_confirmation, :email
 
  scope :recent, lambda{ where('people.created_at <= ?', (Time.now + 1.month)) }
  scope :logged, lambda{ where('last_sign_in_at <= ?', (Time.now + 1.month)).joins(:user) }

  scope :for_grade, lambda { |grade_string|
    # Map the grade string to the 0..12 interpretation
    grade_index = School::GRADES.index(grade_string)
    where(grade: grade_index)
  }

  after_create :create_locker

  def primary_account
    checking_account
  end

  def school
    schools.first
  end

  def name
    first_name + ' ' + last_name
  end

  def to_s
    name
  end

  def purchases_account_name
    checking_account_name
  end

  def purchases_account
    checking_account
  end

  def store_code
    school.store_subdomain
  end

  # FIXME: The account creation on various models needs to be extracted to a module.  #account_name should be all we have to define.
  def checking_account_name
    "STUDENT#{id} CHECKING"
  end

  def savings_account_name
    "STUDENT#{id} SAVINGS"
  end

  def hold_account_name
    "STUDENT#{id} HOLD"
  end

  def checking_account
    Plutus::Asset.find_by_name checking_account_name
  end

  def savings_account
    Plutus::Asset.find_by_name savings_account_name
  end

  def hold_account
    Plutus::Asset.find_by_name hold_account_name
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

  def hold_balance
    hold_account.balance
  end

  def grademates
    school.students.where(grade: self.grade) - [self]
  end

  private
  def ensure_accounts
    checking_account || Plutus::Asset.create(name: checking_account_name)
    savings_account  || Plutus::Asset.create(name: savings_account_name)
    hold_account     || Plutus::Asset.create(name: hold_account_name)
  end


  def create_user
    unless self.user
      if username.present?
        user = Spree::User.create(:username => username, :password => password, :password_confirmation => password_confirmation, :email => email)
      else
        user = Spree::User.create(:email => "student#{self.id}@example.com", :password => 'test123', :password_confirmation => 'test123')
      end
      user.person_id = self.id
      user.save
    end
  end

  def check_coppa
    if self.grade <= 6
      self.last_name = self.last_name[0]
    end
  end

  def create_locker
    locker = Locker.new
    locker.person = self
    locker.save
  end
end
