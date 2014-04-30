require 'spec_helper'

describe Poll do
  describe "grade range" do
    before do
      @poll = FactoryGirl.build(:poll)
    end

    it "should provide a valid grade range" do
      expect(@poll.grade_range).to eq(@poll.min_grade..@poll.max_grade)
    end
  end
end
