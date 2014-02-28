require 'spec_helper'

describe Teacher do
  describe "scopes" do
    describe "recently_logged_in" do
      before do
        @teacher = FactoryGirl.create(:teacher)
        @teacher.user.update_attribute(:last_sign_in_at, 5.days.ago)
        @teacher_2 = FactoryGirl.create(:teacher)
        @teacher_2.user.update_attribute(:last_sign_in_at, 1.month.ago)
      end

      it "should only return teachers having logged in within the last 30 days" do
        expect(Teacher.recently_logged_in).to eq([@teacher])
      end
    end
  end
end
