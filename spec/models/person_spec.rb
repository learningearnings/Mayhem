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

    describe "for_schools" do
      before do
        @person = FactoryGirl.create(:person)
        @person_2 = FactoryGirl.create(:person)
        @school   = FactoryGirl.create(:school)
        @school_2 = FactoryGirl.create(:school)
        FactoryGirl.create(:person_school_link, person: @person, school: @school)
        FactoryGirl.create(:person_school_link, person: @person_2, school: @school_2)
      end

      it "should only show the people for the schools passed in" do
        expect(Person.for_schools([@school.id])).to match_array [@person]
      end
    end
  end

  describe "instance methods" do
    describe "name related methods" do
      before do
        @person = FactoryGirl.build(:person)
      end
      describe "to_s" do
        it "should equal full_name" do
          expect(@person.to_s).to eq(@person.full_name)
        end
      end

      describe "name" do
        it "should concatenate the first and last name" do
          expect(@person.name).to eq(@person.full_name)
        end
      end

      describe "full_name" do
        it "should equal name" do
          expect(@person.name).to eq("#{@person.first_name} #{@person.last_name}")
        end
      end
    end

    describe "classrooms_for_school" do
      before do
        @person       = FactoryGirl.create(:person)
        @school       = FactoryGirl.create(:school)
        @classroom_1  = FactoryGirl.create(:classroom, school: @school)
        @classroom_2  = FactoryGirl.create(:classroom, school: @school)

        @school_link    = FactoryGirl.create(:person_school_link, person: @person, school: @school)

        FactoryGirl.create(:person_school_classroom_link, person_school_link: @school_link, classroom: @classroom_1)
      end

      it "should return the classrooms you are related to for the school provided" do
        #In this case you are only related to classroom_1 even though that school is related to both
        expect(@person.classrooms_for_school(@school)).to match_array([@classroom_1])
      end
    end


    describe "homeroom" do
      before do
        @person = FactoryGirl.create(:person)
        @school = FactoryGirl.create(:school)
        @person_school_link = FactoryGirl.create(:person_school_link, person: @person, school: @school)
        @classroom = FactoryGirl.create(:classroom)
      end

      context "with a homeroom" do
        before do
          FactoryGirl.create(:person_school_classroom_link, person_school_link: @person_school_link, classroom: @classroom, homeroom: true)
        end

        it "should return the homeroom" do
          expect(@person.homeroom).to eq(@classroom)
        end
      end

      context "without a homeroom" do
        before do
          FactoryGirl.create(:person_school_classroom_link, person_school_link: @person_school_link, classroom: @classroom)
        end

        it "it should return nil" do
          expect(@person.homeroom).to be_nil
        end
      end
    end
  end
end
