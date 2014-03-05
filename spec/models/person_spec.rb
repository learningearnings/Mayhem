require 'spec_helper'

describe Person do
  describe "scopes" do
    describe "recently_logged_in" do
      before do
        @person = FactoryGirl.create(:person)
        @person.user.update_attribute(:last_sign_in_at, 5.days.ago)
        @person_2 = FactoryGirl.create(:person)
        @person_2.user.update_attribute(:last_sign_in_at, 1.month.ago)
      end

      it "should only return people having logged in within the last 30 days" do
        expect(Person.recently_logged_in).to eq([@person])
      end
    end
  end
end
