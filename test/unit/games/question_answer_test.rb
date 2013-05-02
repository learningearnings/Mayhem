require 'test_helper'

describe Games::QuestionAnswer do
  subject { Games::QuestionAnswer.new }

  describe "validations" do
    it "requires valid question_id" do
      subject.wont have_valid(:question_id).when(nil)
      subject.wont have_valid(:question_id).when('asdf')
      subject.must have_valid(:question_id).when(1)
    end

    it "requires valid answer_id" do
      subject.wont have_valid(:answer_id).when(nil)
      subject.wont have_valid(:answer_id).when('asdf')
      subject.must have_valid(:answer_id).when(1)
    end

    it "requires valid correct" do
      subject.wont have_valid(:correct).when(nil)
      subject.must have_valid(:correct).when(true)
      subject.must have_valid(:correct).when(false)
    end
  end
end
