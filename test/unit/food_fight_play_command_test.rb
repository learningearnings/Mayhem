require 'test_helper'
require_relative '../../app/models/food_fight_play_command'

describe FoodFightPlayCommand do
  subject { FoodFightPlayCommand.new }

  describe 'validations' do
    before do
      subject.stubs(:answer_ids).returns([])
    end

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

    it "requires valid person_id" do
      subject.wont have_valid(:person_id).when(nil)
      subject.wont have_valid(:person_id).when('asdf')
      subject.must have_valid(:person_id).when(1)
    end
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
    subject.stubs(:correct_answer).returns(nil)
    subject.stubs(:chosen_answer).returns(nil)
    subject.stubs(:question_answers).returns([question_answer])
    subject.answer_options.must_equal [FoodFightPlayCommand::AnswerOption.new(answer)]
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

  it "knows the chosen question_answer" do
    answer_id = 555
    chosen_answer = mock "Question Answer"
    chosen_answer.stubs(:answer_id).returns(answer_id)
    unchosen_answer = mock "Question Answer"
    unchosen_answer.stubs(:answer_id).returns(1)
    question_answers = [chosen_answer, unchosen_answer]
    subject.expects(:question_answers).returns(question_answers)
    subject.answer_id = answer_id
    subject.chosen_question_answer.must_equal chosen_answer
  end

  it "knows the chosen answer" do
    answer = mock "Answer"
    chosen_answer = mock "Question Answer"
    chosen_answer.expects(:answer).returns(answer)
    subject.stubs(:chosen_question_answer).returns(chosen_answer)
    subject.chosen_answer.must_equal answer
  end

  it "responds properly to #question_body" do
    question = mock "Question"
    subject.expects(:question).returns(question)
    question.expects(:body).returns("foo")
    subject.question_body.must_equal "foo"
  end

  it "persists the answer when executed" do
    question_answer = mock "QuestionAnswer"
    question_answer.expects(:id).returns(2)
    subject.stubs(:chosen_question_answer).returns(question_answer)
    person_answer_repository = mock("PersonAnswer")
    subject.stubs(:person_answer_repository).returns(person_answer_repository)
    subject.question_id = 3
    subject.person_id = 1
    person_answer_args = {
      person_id: 1,
      question_answer_id: 2,
      question_id: 3
    }
    subject.stubs(:valid?).returns true
    subject.stubs(:correct?).returns true
    on_success = mock "Callback"
    on_success.expects(:call).with(subject)
    subject.stubs(:on_success).returns(on_success)
    created_answer = mock "PersonAnswer"
    created_answer.expects(:valid?).returns(true)
    person_answer_repository.expects(:create).with(person_answer_args).returns(created_answer)
    subject.execute!
  end
end
