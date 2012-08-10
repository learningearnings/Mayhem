require 'test_helper'

describe AccountPersonMapper do
  subject { AccountPersonMapper.new }

  it "should know a person_id when given an account" do
    subject.account_name = "STUDENT6"
    subject.person_id.must_equal 6
  end
end
