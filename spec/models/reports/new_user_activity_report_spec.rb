require 'spec_helper'

describe Reports::NewUserActivityReport do
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

    student.associate_accounts
    student_2.associate_accounts
    student_3.associate_accounts
    student.checking_account.update_attribute(:cached_balance, BigDecimal("1000"))
    student_2.savings_account.update_attribute(:cached_balance, BigDecimal("200"))
    student_3.checking_account.update_attribute(:cached_balance, BigDecimal("15"))

    OtuCode.create(:redeemed_at => Time.zone.now, :points => BigDecimal("10"))
    OtuCode.create(:redeemed_at => 31.days.ago, :points => BigDecimal("10"))
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

  it "should show the correct student balance" do
    expect(@global_row[9]).to eq(1215)
  end

  it "should show the correct deposited credits" do
    expect(@global_row[10]).to eq(10)
  end
end
