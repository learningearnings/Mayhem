require 'test_helper_with_rails'

describe Classroom do
  subject { Classroom }

  it "has the basics down" do
    subject.must_be_kind_of Class
  end

  describe "Validations" do
    it "wont have a valid name" do
      subject.new.wont have_valid(:name).when(nil)
    end
  end
end
