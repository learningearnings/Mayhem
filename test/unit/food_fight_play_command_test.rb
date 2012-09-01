require 'test_helper'

describe FoodFightPlayCommand do
  subject { FoodFightPlayCommand.new }

  it "requires valid question_id" do
    subject.wont have_valid(:question_id).when(nil)
    subject.wont have_valid(:question_id).when('asdf')
    subject.must have_valid(:question_id).when(1)
  end

  it "requires valid answer_id" do
    subject.stubs(:answer_ids).returns([2,3])
    subject.wont have_valid(:answer_id).when(nil)
    subject.wont have_valid(:answer_id).when('asdf')
    subject.wont have_valid(:answer_id).when(1)
    subject.must have_valid(:answer_id).when(2)
  end

  it "responds properly to #question_body" do
    question = mock "Question"
    subject.expects(:question).returns(question)
    question.expects(:body).returns("foo")
    subject.question_body.must_equal "foo"
  end

  it "responds properly to #question_answers" do
    question_answer_repository = mock "QuestionAnswer Class"
    question_answer = mock "QuestionAnswer"
    question_answer_repository.expects(:all).returns([question_answer])
    subject.expects(:question_answer_repository).returns(question_answer_repository)
    subject.question_answers.must_equal [question_answer]
  end

  it "responds properly to #answer_options" do
    answer = {}
    question_answer = mock "QuestionAnswer"
    question_answer.expects(:answer).returns(answer)
    subject.expects(:question_answers).returns([question_answer])
    subject.answer_options.must_equal [answer]
  end

  it "knows the correct answer" do
    wrong_answer = mock "QuestionAnswer"
    wrong_answer.stubs(:correct?).returns(false)
    right_answer = mock "QuestionAnswer"
    right_answer.stubs(:correct?).returns(true)
    answer = mock("Answer")
    right_answer.expects(:answer).returns(answer)
    subject.expects(:question_answers).returns([wrong_answer, right_answer])
    subject.correct_answer.must_equal answer
  end

  it "knows the chosen answer" do
    answer_id = 555
    answer = mock "Answer"
    chosen_answer = mock "Question Answer"
    chosen_answer.stubs(:id).returns(answer_id)
    chosen_answer.expects(:answer).returns(answer)
    unchosen_answer = mock "Question Answer"
    unchosen_answer.stubs(:id).returns(1)
    question_answers = [chosen_answer, unchosen_answer]
    subject.expects(:question_answers).returns(question_answers)
    subject.answer_id = answer_id
    subject.chosen_answer.must_equal answer
  end

  it "requires valid person_id" do
    subject.wont have_valid(:person_id).when(nil)
    subject.wont have_valid(:person_id).when('asdf')
    subject.must have_valid(:person_id).when(1)
  end

  it "responds properly to #question_body" do
    question = mock "Question"
    subject.expects(:question).returns(question)
    question.expects(:body).returns("foo")
    subject.question_body.must_equal "foo"
  end
end
