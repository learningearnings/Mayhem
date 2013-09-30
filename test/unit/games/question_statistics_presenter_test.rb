require 'test_helper'

describe Games::QuestionStatisticsPresenter do
  before do
    @question = mock "Question"
    @presenter = Games::QuestionStatisticsPresenter.new(@question)
  end

  it "knows how many times the question has been answered" do
    answer_repo = mock "Games::PersonAnswer"
    answer_repo.expects(:count).returns(500)
    @presenter.expects(:person_answer_repository).returns(answer_repo)
    @presenter.number_of_answers.must_equal 500
  end

  it "knows how many times the question has been answered correctly" do
    correct_answers = mock "Correct Answers"
    correct_answers.expects(:count).returns(200)
    @presenter.expects(:correct_answers).returns(correct_answers)
    @presenter.number_of_correct_answers.must_equal 200
  end

  it "knows how many times the question has been answered incorrectly" do
    @presenter.expects(:number_of_answers).returns(500)
    @presenter.expects(:number_of_correct_answers).returns(200)
    @presenter.number_of_incorrect_answers.must_equal(300)
  end
end
