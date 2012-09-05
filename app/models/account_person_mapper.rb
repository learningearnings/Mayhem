# This is a class used to map people to their respective accounts.
# Useful for finding a person when you only have their account number.
# Also, a handy place to define what the mapping is.
class AccountPersonMapper
  attr_accessor :account_name

  def initialize account_name
    @account_name = account_name
  end

  def person_id
    account_name.gsub(/[^\d]/, '').to_i unless account_name.nil?
  end

  def school_id
    account_name.gsub(/[^\d]/, '').to_i unless account_name.nil?
  end

  def find_person
    type.find person_id unless person_id.nil?
  end

  def find_school
    type.find school_id unless school_id.nil?
  end

  def type
    case account_name
    when /^STUDENT/
      Student
    when /^SCHOOL/
      School
    end
  end
end
