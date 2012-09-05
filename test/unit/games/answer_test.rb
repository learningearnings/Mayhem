require 'test_helper'

describe Games::Answer do
  subject { Games::Answer.new }

  describe "validations" do
    it "requires valid body" do
      subject.wont have_valid(:body).when(nil)
      subject.must have_valid(:body).when('asdf')
    end

    it "requires valid game_type" do
      subject.wont have_valid(:game_type).when(nil)
      subject.must have_valid(:game_type).when('MultiChoice')
    end

    it "responds to to_s with body" do
      subject.body = "foo"
      subject.to_s.must_equal "foo"
    end
  end
end
