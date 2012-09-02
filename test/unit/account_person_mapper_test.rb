require 'test_helper'
require_relative '../../app/models/account_person_mapper'

describe AccountPersonMapper do
  subject { AccountPersonMapper.new("STUDENT6") }

  it "should know a person_id when given an account" do
    subject.person_id.must_equal 6
  end
end
