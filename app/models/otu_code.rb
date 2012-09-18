class OtuCode < ActiveRecord::Base
  attr_accessible :points, :code, :student_id, :person_school_link_id, :expires_at, :ebuck, :student, :person_school_link
  has_many :transactions, :through => :otu_transaction_links
  has_many :buck_batches, :through => :buck_batch_links
  has_many :buck_batch_links
  belongs_to :student
  belongs_to :person_school_link
  has_one :teacher, :through => :person_school_link, :source => :person
  has_one :school, :through => :person_school_link

  scope :active,  lambda { where("active = ?", true) }
  scope :not_expired, lambda { where("created_at > ?", Time.now - 45.days)}

  def expired?
    self.created_at > (Time.now + 45.days)
  end

  def is_ebuck?
    ebuck?
  end

  def generate_code(prefix)
    _code = Code.active[rand(Code.active.count)]
    _full_code = prefix + _code.code
    self.update_attribute(:code, _full_code)
    _code.update_attributes(:active => false, :used_date => Time.now)
  end
end
