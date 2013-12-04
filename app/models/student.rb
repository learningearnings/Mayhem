class Student < Person
  before_save :check_coppa
  after_create :ensure_accounts

  before_validation :ensure_new_user
  after_create :create_user

  validates_presence_of :grade

  has_many :otu_codes
  has_one :locker, foreign_key: :person_id

  attr_accessor :username, :password, :password_confirmation

  scope :recent, lambda{ where('people.created_at <= ?', (Time.now + 1.month)) }
  scope :logged, lambda{ where('last_sign_in_at <= ?', (Time.now + 1.month)).joins(:user) }

  scope :for_grade, lambda { |grade_string|
    # Map the grade string to the 0..12 interpretation
    grade_index = School::GRADES.index(grade_string)
    where(grade: grade_index)
  }

  scope :for_gender, lambda { |gender| where(:gender => gender) }

  before_create :set_status_to_active
  after_create :create_locker

  def main_account(s)
    checking_account
  end

  def primary_account
    checking_account
  end

  def school
    schools.first
  end

  def school=(my_new_school)
    my_new_school_id = my_new_school.is_a?(School) ? my_new_school.id : my_new_school
    self.person_school_links.status_active.each do |psl|
      return if my_new_school_id == psl.school_id
      psl.deactivate
      psl.save
    end
    super
  end

  def name
    first_name + ' ' + last_name
  end

  def admin_title
    'Student #' + id.to_s + '( ' + user.username + ')'
  end

  def to_s
    name
  end

  def accounts (school)
    [checking_account, savings_account, hold_account]
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
    @student_checking_account ||= Plutus::Asset.find_by_name checking_account_name
  end

  def savings_account
    @student_savings_account ||= Plutus::Asset.find_by_name savings_account_name
  end

  def hold_account
    @student_hold_account ||= Plutus::Asset.find_by_name hold_account_name
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

  def ensure_new_user
    self.user = Spree::User.new(:username => username, :password => password, :password_confirmation => password_confirmation)
    unless self.user.valid?
      errors.add(:user, "User is invalid.") and return
    end
  end

  def create_user
    user.person_id = self.id
    user.save
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

  def set_status_to_active
    self.status = 'active' # Students should default to active
  end
end
