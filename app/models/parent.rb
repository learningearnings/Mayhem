class Parent < Person
	belongs_to :student
  #after_create :ensure_accounts
	accepts_nested_attributes_for :user, :allow_destroy => true
  attr_accessible :user_attributes
  before_create :set_status_to_active
  attr_accessor :skip_password_validation
  before_save :set_password 

  def school
    schools.where("person_school_links.status = 'active'").order('created_at desc').first
  end

  private
    def set_status_to_active
      self.status = 'active' # Students should default to active
    end

    def set_password
      self.skip_password_validation = true
    end

  protected
    def password_required?
      return false if skip_password_validation
      super
    end
end
