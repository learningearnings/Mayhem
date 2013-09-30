require 'test_helper_with_rails'

describe Spree::User do
  before do
    @user     = FactoryGirl.create(:spree_user)
    @person   = FactoryGirl.create(:person, :user => @user)
    @user.stubs(:person).returns(@person)
  end

  describe "User#moniker" do
    it "should return the users persons moniker" do
      assert_equal @user.moniker, @user.person.moniker
    end
  end

  describe "User#moniker=" do
    it "should call moniker= on the person" do
      @person.expects(:moniker=).once
      @user.moniker = "New Moniker"
    end
  end
end

