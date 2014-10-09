class Teacher < Person
  has_many :schools, :through => :person_school_links
  attr_accessor :username, :password, :password_confirmation, :email
  attr_accessible :gender, :email, :username, :game_challengeable, :can_distribute_credits
  attr_accessible :status, :can_distribute_credits, :game_challengeable, :as => :admin
  validates_presence_of :grade
  after_create :create_user

  scope :game_challengeable, lambda{ where('game_challengeable = ?', true)}
  scope :awaiting_approval, lambda{ where('status = ?', 'awaiting_approval')}
  scope :not_awaiting_approval, lambda{ where('status != ?', 'awaiting_approval')}

  has_many :reward_distributors, :through => :person_school_links
  has_many :otu_codes, through: :person_school_links

  before_create :set_status_to_active

  def after_initialize
    @teacher_main_account = []
    @teacher_undredeemed_account = []
    @teacher_undeposited_account = []
  end

  def set_status_to_active
    self.status = 'active'
  end

  def primary_account
    main_account(self.schools.first)
  end

  def can_distribute_rewards? s
    return false unless (s && s.is_a?(School))
    self.person_school_links.joins(:reward_distributors).exists?(:school_id => s.id)
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
    @teacher_main_account ||= []
    return @teacher_main_account[school.id] if @teacher_main_account[school.id]
    @teacher_main_account[school.id] = Plutus::Asset.find_by_name main_account_name(school)
    @teacher_main_account[school.id]
  end

  def unredeemed_account(school)
    @teacher_unredeemed_account ||= []
    return @teacher_unredeemed_account[school.id] if @teacher_unredeemed_account[school.id]
    @teacher_unredeemed_account[school.id] = Plutus::Asset.find_by_name unredeemed_account_name(school)
    @teacher_unredeemed_account[school.id]
  end

  def undeposited_account(school)
    @teacher_undeposited_account ||= []
    return @teacher_undeposited_account[school.id] if @teacher_undeposited_account[school.id]
    @teacher_undeposited_account[school.id] = Plutus::Asset.find_by_name undeposited_account_name(school)
    @teacher_undeposited_account[school.id]
  end

  def accounts(school = nil)
    # FIXME: I hate this -ja
    # Plutus::Account.where "name LIKE '%TEACHER#{id}%'"
    if school
      these_schools = [school]
    else
      these_schools = self.schools
    end
    these_schools.collect do |s|
      [
       main_account(s),
       unredeemed_account(s),
       undeposited_account(s)
      ]
      end.flatten
  end

  def balance
    schools.collect do |s|
      main_account(s).balance
    end
  end

  def name
    first_name + ' ' + last_name
  end

  # Don't love that bizlogic is right here, but hey...
  def students_ive_given_ebucks_to
    Student.includes(otu_codes: [ :teacher ]).where("otu_codes.id IS NOT NULL").where(otu_codes: { teacher: { id: id } })
  end

  def setup_accounts(school)
    Plutus::Asset.find_by_name(main_account_name(school)) || Plutus::Asset.create(name: main_account_name(school))
    Plutus::Asset.find_by_name(unredeemed_account_name(school)) || Plutus::Asset.create(name: unredeemed_account_name(school))
    Plutus::Asset.find_by_name(undeposited_account_name(school)) || Plutus::Asset.create(name: undeposited_account_name(school))
  end

  def create_user
    unless self.user
      if username.present?
        user = Spree::User.create(:username => username, :email => email, :password => password, :password_confirmation => password_confirmation)
      else
        user = Spree::User.create(:username => 'test_user', :email => "test_user@example.com", :password => 'test123', :password_confirmation => 'test123')
      end
    else
      user = self.user
      user.update_attributes(:username => username, :email => email, :password => password, :password_confirmation => password_confirmation)
    end
    user.person_id = self.id
    user.save
  end

  def peers_at(school)
    school.teachers - [self]
  end

  def synced?
    district_guid.present? && sti_id.present?
  end
end
