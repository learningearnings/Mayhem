require 'spec_helper.rb'
describe BuckDistributor do
  describe "determining amount for schools" do
    describe "with a student that isn't active" do
      before do
        Timecop.freeze(Time.parse("January 1st"))
        @buck_distributor = BuckDistributor.new
        @school           = FactoryGirl.create(:school)
        @student          = FactoryGirl.create(:student)
        @student_2        = FactoryGirl.create(:student)
        @student_3        = FactoryGirl.create(:student)
        [@student, @student_2].each do |student|
          PersonSchoolLink.new(:school_id => @school.id, :person_id => student.id).save(:validate => false)
          student.user.update_attribute(:last_sign_in_at, Time.now)
        end
        PersonSchoolLink.new(:school_id => @school.id, :person_id => @student_3.id).save(:validate => false)
        @student_3.user.update_attribute(:last_sign_in_at, 32.days.ago)
      end

      after do
        Timecop.return
      end

      it "should calculate the correct amount" do
        expect(@buck_distributor.amount_for_school(@school)).to eq(1550)
      end
    end

    context "with 11 days left in the month" do
      before do
        Timecop.freeze(Time.parse("January 21st"))
        @school           = FactoryGirl.create(:school)
        @student          = FactoryGirl.create(:student)
        @student_2        = FactoryGirl.create(:student)
        [@student, @student_2].each do |student|
          PersonSchoolLink.new(:school_id => @school.id, :person_id => student.id).save(:validate => false)
          student.user.update_attribute(:last_sign_in_at, Time.now)
        end
        @buck_distributor = BuckDistributor.new([@school], CreditManager.new)
      end

      after do
        Timecop.return
      end

      it "should calculate the correct amount" do
        expect(@buck_distributor.amount_for_school(@school)).to eq(550)
      end
    end

    context "with 1 day left in the month" do
      before do
        Timecop.freeze(Time.parse("January 31st"))
        @school           = FactoryGirl.create(:school)
        @student          = FactoryGirl.create(:student)
        @student_2        = FactoryGirl.create(:student)
        [@student, @student_2].each do |student|
          PersonSchoolLink.new(:school_id => @school.id, :person_id => student.id).save(:validate => false)
          student.user.update_attribute(:last_sign_in_at, Time.now)
        end
        @buck_distributor = BuckDistributor.new([@school], CreditManager.new)
      end

      after do
        Timecop.return
      end

      it "should calculate the correct amount" do
        expect(@buck_distributor.amount_for_school(@school)).to eq(50)
      end
    end
  end
end
