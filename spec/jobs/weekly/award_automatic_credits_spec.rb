require 'spec_helper'

describe Jobs::Weekly::AwardAutomaticCredits do
  describe "#run" do
    let(:school) { FactoryGirl.create(:school) }
    let(:job)    { Jobs::Weekly::AwardAutomaticCredits.new(school.id) }
    

    it "raises an error without a school" do
      expect { Jobs::Weekly::AwardAutomaticCredits.new }.to raise_error(ArgumentError)
    end

    it "credits a student with no tardies" do
      # WIP
    end

    it "credits a student with no infractions" do
      # WIP
    end

    it "credits a student with perfect attendance" do
      # WIP
    end

    it "does not credit a student with tardies" do
      # WIP
    end

    it "does not credit a student with infractions" do
      # WIP
    end

    it "does not credit a student without perfect attendance" do
      # WIP
    end
  end
end
