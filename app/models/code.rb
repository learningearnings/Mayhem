require 'uuidtools'

class Code < ActiveRecord::Base
  scope :active,  lambda { where("active = ?", true) }
  before_validation :gen_code, :on => :create
  validates_uniqueness_of :code

  attr_accessible :used_date, :active

  def gen_code
    _code = Code.generate_code(self.id)
    write_attribute(:code, _code)
  end

  def self.reverse_code(code)
    code[2..-1].tr(ambiguous_letter_replacements,ambiguous_letters).to_i(30)
  end

  def self.reverse_legacy_code(code)
    code[2..-1].to_i(30)
  end


  def self.generate_code(id)
    UUIDTools::UUID.random_create.to_s[0..6].upcase
  end

  def self.ambiguous_letters
    "l15oi0 "
  end

  def self.ambiguous_letter_replacements
    "UVWXYZ"
  end
end
