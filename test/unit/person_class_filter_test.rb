require 'test_helper'

describe PersonClassFilter do
  subject { PersonClassFilter }

  it "has the basics down" do
    subject.must_be_kind_of Class
  end

  describe "Validations" do
    it "wont have a valid filter_id" do
     subject.new.wont have_valid(:filter_id).when(nil)
    end
  end
end

