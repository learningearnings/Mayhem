require 'test_helper_with_rails'

describe Spree::User do
  before do
    @user     = FactoryGirl.create(:spree_user)
    @person   = FactoryGirl.create(:person, :user => @user)
    @user.stubs(:person).returns(@person)
  end

  describe "User#display_name" do
    it "should return the users persons display name" do
      assert_equal @user.display_name, @user.person.display_name
    end
  end

  describe "User#display_name=" do
    it "should call display_name= on the person" do
      @person.expects(:display_name=).once
      @user.display_name = "New Display Name"
    end
  end
end

