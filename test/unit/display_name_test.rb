require 'test_helper'

describe DisplayName do
  describe "auto approve" do
    it "should auto approve display names that have already been approved elsewhere" do
      person = FactoryGirl.create(:person)
      approved_display_name = person.display_names.create(:display_name => "Great Name")
      approved_display_name.approve!

      person_2 = FactoryGirl.create(:person)
      auto_approved_display_name = person_2.display_names.create(:display_name => "Great Name")
      assert_equal auto_approved_display_name.state, "approved"
    end

    it "should not auto approve display names that don't match" do
      person = FactoryGirl.create(:person)
      approved_display_name = person.display_names.create(:display_name => "Great Name")
      approved_display_name.approve!

      person_2 = FactoryGirl.create(:person)
      auto_approved_display_name = person_2.display_names.create(:display_name => "Great Name 1")
      assert_equal auto_approved_display_name.state, "requested"
    end

    it "should not auto approve display names that aren't already approved" do
      person = FactoryGirl.create(:person)
      approved_display_name = person.display_names.create(:display_name => "Great Name")

      person_2 = FactoryGirl.create(:person)
      auto_approved_display_name = person_2.display_names.create(:display_name => "Great Name")
      assert_equal auto_approved_display_name.state, "requested"
    end
  end
end
