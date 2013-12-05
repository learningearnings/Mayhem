require 'test_helper_with_rails'

describe Spree::User do
  before do
    @user     = FactoryGirl.create(:spree_user)
    @person   = FactoryGirl.create(:person, :user => @user)
    @user.stubs(:person).returns(@person)
  end
end

