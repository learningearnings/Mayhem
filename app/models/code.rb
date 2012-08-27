class Code < ActiveRecord::Base
  scope :active, where(:status == true)
  after_create :gen_code

  def gen_code
    _code = Code.generate_code(self.id)
    self.update_attribute(:code, _code)
  end

  def self.generate_code(id)
    ("%6s" % id.to_s(30)).tr(ambiguous_letters, ambiguous_letter_replacements).upcase
  end

  def self.ambiguous_letters
    "l15oi0 "
  end

  def self.ambiguous_letter_replacements
    "UVWXYZ"
  end
end
