require 'spec_helper.rb'
describe BuckDistributor do
  describe "determining amount for schools" do
    describe "without prorating" do
      before do
        @buck_distributor = BuckDistributor.new
        @school           = FactoryGirl.create(:school)
        @student          = FactoryGirl.create(:student)
        @student_2        = FactoryGirl.create(:student)
        [@student, @student_2].each do |student|
          PersonSchoolLink.new(:school_id => @school.id, :person_id => student.id).save(:validate => false)
          student.user.update_attribute(:last_sign_in_at, Time.now)
        end
      end

      it "should calculate the correct amount" do
        expect(@buck_distributor.amount_for_school(@school)).to eq(1400)
      end
    end

    describe "with prorating" do
      context "with 10 days left in the month" do
        before do
          Timecop.freeze(Time.parse("January 21st"))
          @school           = FactoryGirl.create(:school)
          @student          = FactoryGirl.create(:student)
          @student_2        = FactoryGirl.create(:student)
          [@student, @student_2].each do |student|
            PersonSchoolLink.new(:school_id => @school.id, :person_id => student.id).save(:validate => false)
            student.user.update_attribute(:last_sign_in_at, Time.now)
          end
          @buck_distributor = BuckDistributor.new([@school], CreditManager.new, true)
        end

        after do
          Timecop.return
        end

        it "should calculate the correct amount" do
          expect(@buck_distributor.amount_for_school(@school)).to eq(497)
        end
      end

      context "with 31 days left in the month" do
        before do
          Timecop.freeze(Time.parse("January 1st"))
          @school           = FactoryGirl.create(:school)
          @student          = FactoryGirl.create(:student)
          @student_2        = FactoryGirl.create(:student)
          [@student, @student_2].each do |student|
            PersonSchoolLink.new(:school_id => @school.id, :person_id => student.id).save(:validate => false)
            student.user.update_attribute(:last_sign_in_at, Time.now)
          end
          @buck_distributor = BuckDistributor.new([@school], CreditManager.new, true)
        end

        after do
          Timecop.return
        end

        it "should calculate the correct amount" do
          expect(@buck_distributor.amount_for_school(@school)).to eq(1400)
        end
      end
    end
  end
end
