require 'test_helper'

describe Moniker do
  describe "auto approve" do
    it "should auto approve monikers that have already been approved elsewhere" do
      person = FactoryGirl.create(:person)
      approved_moniker = person.monikers.create(:moniker => "Great Name")
      approved_moniker.approve!

      person_2 = FactoryGirl.create(:person)
      auto_approved_moniker = person_2.monikers.create(:moniker => "Great Name")
      assert_equal auto_approved_moniker.state, "approved"
    end

    it "should not auto approve monikers that don't match" do
      person = FactoryGirl.create(:person)
      approved_moniker = person.monikers.create(:moniker => "Great Name")
      approved_moniker.approve!

      person_2 = FactoryGirl.create(:person)
      auto_approved_moniker = person_2.monikers.create(:moniker => "Great Name 1")
      assert_equal auto_approved_moniker.state, "requested"
    end

    it "should not auto approve monikers that aren't already approved" do
      person = FactoryGirl.create(:person)
      approved_moniker = person.monikers.create(:moniker => "Great Name")

      person_2 = FactoryGirl.create(:person)
      auto_approved_moniker = person_2.monikers.create(:moniker => "Great Name")
      assert_equal auto_approved_moniker.state, "requested"
    end
  end
end
