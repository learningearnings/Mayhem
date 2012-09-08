require 'test_helper_with_rails'

describe Locker do
  subject { Locker.new }

  describe "[validations]" do
    it "requires a person_id" do
      subject.wont have_valid(:person_id).when(nil)
      subject.must have_valid(:person_id).when(1)
    end
  end
end
