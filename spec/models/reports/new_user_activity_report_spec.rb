require 'spec_helper'

describe Reports::NewUserActivityReport do
  context "recently created teachers and a students" do
    before do
      teacher = FactoryGirl.create(:teacher)
      teacher_2 = FactoryGirl.create(:teacher)
      teacher_2.user.update_attribute(:last_sign_in_at, 1.day.ago)
      teacher_3 = FactoryGirl.create(:teacher, :created_at => 1.year.ago)
      student = FactoryGirl.create(:student)
      student_2 = FactoryGirl.create(:student)
      student_2.user.update_attribute(:last_sign_in_at, 1.day.ago)
      student_3 = FactoryGirl.create(:student, :created_at => 1.year.ago)
      school = FactoryGirl.create(:school)
      report = Reports::NewUserActivityReport.new
      @global_row = report.send(:build_global_row)
    end

    it "should show the appropriate amount of total teachers" do
      expect(@global_row[2]).to eq(3)
    end

    it "should show the appropriate amount of active teachers" do
      expect(@global_row[3]).to eq(1)
    end

    it "should show the appropriate amount of recently created teachers" do
      expect(@global_row[4]).to eq(2)
    end

    it "should show the appropriate amount of total students" do
      expect(@global_row[5]).to eq(3)
    end

    it "should show the appropriate amount of active students" do
      expect(@global_row[6]).to eq(1)
    end

    it "should show the approriate amount of recently created students" do
      expect(@global_row[7]).to eq(2)
    end
  end
end
