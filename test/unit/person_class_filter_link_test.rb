require 'test_helper'

describe PersonClassFilterLink do
  subject { PersonClassFilterLink }

  it "has the basics down" do
    subject.must_be_kind_of Class
  end

  describe "Validations" do
    it "wont have a valid filter_id" do
     subject.new.wont have_valid(:filter_id).when(nil)
    end
  end
end

