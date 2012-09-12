class Teacher < Person

  has_many :schools, :through => :person_school_links
  attr_accessor :username, :password, :password_confirmation, :email
  attr_accessible :username, :password, :password_confirmation, :email, :gender
  validates_presence_of :grade
  after_create :create_user

  def primary_account
    main_account(self.schools.first)
  end

  # FIXME: The account creation on various models needs to be extracted to a module.  #account_name should be all we have to define.
  def main_account_name(school)
    "TEACHER#{id} MAIN SCHOOL#{school.id}"
  end

  def unredeemed_account_name(school)
    "TEACHER#{id} UNREDEEMED SCHOOL#{school.id}"
  end

  def undeposited_account_name(school)
    "TEACHER#{id} UNDEPOSITED SCHOOL#{school.id}"
  end

  def main_account(school)
    Plutus::Asset.find_by_name main_account_name(school)
  end

  def unredeemed_account(school)
    Plutus::Asset.find_by_name unredeemed_account_name(school)
  end

  def undeposited_account(school)
    Plutus::Asset.find_by_name undeposited_account_name(school)
  end

  def accounts
    # FIXME: I hate this -ja
    Plutus::Account.where "name LIKE '%TEACHER#{id}%'"
  end

  def balance
    schools.collect do |s| 
      main_account(s).balance
    end
  end

  #def username
  #  self.name.gsub(' ', '').underscore 
  #end

  def name
    first_name + ' ' + last_name
  end

  def setup_accounts(school)
    main_account(school)        || Plutus::Asset.create(name: main_account_name(school))
    unredeemed_account(school)  || Plutus::Asset.create(name: unredeemed_account_name(school))
    undeposited_account(school) || Plutus::Asset.create(name: undeposited_account_name(school))
  end

  def create_user
    unless self.user
      if username.present?
        user = Spree::User.create(:username => username, :email => email, :password => password, :password_confirmation => password_confirmation)
      else
        binding.pry
        user = Spree::User.create(:username => 'test_user', :email => "test_user@example.com", :password => 'test123', :password_confirmation => 'test123')
      end
      user.person_id = self.id
      user.save
    end
  end


end
