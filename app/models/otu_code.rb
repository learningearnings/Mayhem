class OtuCode < ActiveRecord::Base

  attr_accessible :points, :code, :student_id, :person_school_link_id, :expires_at, :ebuck
  has_many :transactions, :through => :otu_transaction_link

  def is_ebuck?
    ebuck
  end

  def generate_code(prefix)
    _code = Code.active[rand(Code.active.count)]
    _full_code = prefix + _code.code
    self.update_attribute(:code, _full_code)
    _code.update_attributes(:active => false, :used_date => Time.now)
  end
end
