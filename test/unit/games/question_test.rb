require 'test_helper'

describe Games::Question do
  subject { Games::Question.new }

  describe "validations" do
=begin
    it "requires valid number_of_answers" do
      subject.wont have_valid(:number_of_answers).when(nil)
      subject.wont have_valid(:number_of_answers).when('adsf')
      subject.must have_valid(:number_of_answers).when(4)
    end
=end

    it "requires valid grade" do
      subject.wont have_valid(:grade).when(nil)
      subject.wont have_valid(:grade).when('adsf')
      subject.must have_valid(:grade).when(4)
    end

    it "requires valid body" do
      subject.wont have_valid(:body).when(nil)
      subject.must have_valid(:body).when('asdf')
    end

    it "requires valid game_type" do
      subject.wont have_valid(:game_type).when('foo')
      subject.must have_valid(:game_type).when('FoodFight')
    end
  end
end
