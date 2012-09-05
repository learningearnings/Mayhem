require 'test_helper'

describe Filter do
  subject { Filter }

  it "has the basics down" do
    subject.must_be_kind_of Class
  end

  describe "Validations" do
    it "wont have a valid minimum_grade" do
      subject.new.wont have_valid(:minimum_grade).when(nil)
    end

    it "wont have a valid maximum_grade" do
      subject.new.wont have_valid(:maximum_grade).when(nil)
    end
  end
end
