class Teacher < Person
#  has_many :person_school_classroom_links,:class_name => 'PersonSchoolClassroomLink', :source => :person_school_links
#  has_many :classrooms, :through => :person_school_classroom_links, :source => :classroom

  after_create :ensure_account

  # FIXME: The account creation on various models needs to be extracted to a module.  #account_name should be all we have to define.
  def account_name
    "TEACHER#{id}"
  end

  def account
    Plutus::Asset.find_by_name account_name
  end

  def balance
    account.balance
  end

  private
  # FIXME: There needs to be an account per teacher per school.  This part doesn't so much work long term
  def ensure_account
    account || Plutus::Asset.create(name: account_name)
  end
end
