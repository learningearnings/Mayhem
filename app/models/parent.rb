class Parent < Person
	has_and_belongs_to_many :student
  #after_create :ensure_accounts
	accepts_nested_attributes_for :user, :allow_destroy => true
  attr_accessible :user_attributes
  before_create :set_status_to_active

  def school
    schools.where("person_school_links.status = 'active'").order('created_at desc').first
  end

  private
    def set_status_to_active
      self.status = 'active' # Students should default to active
    end
end
