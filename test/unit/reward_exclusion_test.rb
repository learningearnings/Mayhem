require 'test_helper_with_rails'

describe RewardExclusion do
  subject { RewardExclusion.new }

  describe ":validations:" do
    it "must have a school_id" do
      subject.wont have_valid(:school_id).when(nil)
      subject.must have_valid(:school_id).when(1)
    end
    it "must have a product_id" do
      subject.wont have_valid(:product_id).when(nil)
      subject.must have_valid(:product_id).when(1)
    end
  end
end
