require 'test_helper'

describe AccountPersonMapper do
  subject { AccountPersonMapper.new("STUDENT6") }

  it "should know a person_id when given an account" do
    subject.person_id.must_equal 6
  end
end
