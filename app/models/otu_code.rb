class OtuCode < ActiveRecord::Base

  attr_accessible :points, :code, :student_id, :person_school_link_id, :expires_at, :ebuck
  has_many :transactions, :through => :otu_transaction_link

  scope :active,  lambda { where("active = ?", true) }

  def is_ebuck?
    ebuck
  end

  def person_school_link
    PersonSchoolLink.find(self.person_school_link_id)
  end

  def teacher
    self.person_school_link.person
  end

  def school
    self.person_school_link.school
  end

  def generate_code(prefix)
    _code = Code.active[rand(Code.active.count)]
    _full_code = prefix + _code.code
    self.update_attribute(:code, _full_code)
    _code.update_attributes(:active => false, :used_date => Time.now)
  end
end
