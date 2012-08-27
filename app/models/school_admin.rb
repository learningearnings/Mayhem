class SchoolAdmin < Person

  has_many :schools, :through => :person_school_links
  after_create :create_user

  # FIXME: The account creation on various models needs to be extracted to a module.  #account_name should be all we have to define.
  def main_account_name(school)
    "SCHOOL ADMIN#{id}"
  end

  def unredeemed_account_name(school)
    "SCHOOL ADMIN#{id}"
  end

  def undeposited_account_name(school)
    "SCHOOL ADMIN#{id}"
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
    Plutus::Account.where "name LIKE '%SCHOOL ADMIN#{id}%'"
  end

  def balance
    main_account(schools.first).balance
  end

  def name
    first_name + ' ' + last_name
  end

  def username
    self.name.gsub(' ', '').underscore
  end

  def setup_accounts(school)
    main_account(school)        || Plutus::Asset.create(name: main_account_name(school))
    unredeemed_account(school)  || Plutus::Asset.create(name: unredeemed_account_name(school))
    undeposited_account(school) || Plutus::Asset.create(name: undeposited_account_name(school))
  end

  private
  def create_user
    user = Spree::User.create(:email => "#{self.username}@example.com", :password => 'test123', :password_confirmation => 'test123')
    user.person = self
    user.save
  end

end
