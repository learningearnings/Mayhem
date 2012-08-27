class Code < ActiveRecord::Base
  scope :active, where(:status == true)
  after_create :gen_code

  def gen_code
    _code = ("%6s" % self.id.to_s(30)).tr("l15oi0 ","UVWXYZ").upcase
    self.update_attribute(:code, _code)
  end

end
