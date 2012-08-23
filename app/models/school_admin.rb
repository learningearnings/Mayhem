class SchoolAdmin < Person

  has_many :schools, :through => :person_school_links
  after_create :create_user

  def main_account_name(school)
    "SCHOOL ADMIN#{id} MAIN SCHOOL#{school.id}"
  end

  def accounts
    # FIXME: I hate this -ja
    Plutus::Account.where "name LIKE '%SCHOOL ADMIN#{id}%'"
  end

  def setup_accounts(school)
    main_account(school)        || Plutus::Asset.create(name: main_account_name(school))
  end

  def name
    first_name + ' ' + last_name
  end

  def username
    self.name.gsub(' ', '').underscore 
  end

  private
  def create_user
    user = Spree::User.create(:email => "#{self.username}@example.com", :password => 'test123', :password_confirmation => 'test123')
    user.person = self
    user.save
  end

end
