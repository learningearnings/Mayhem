require_relative './active_model_command'
require 'delegate'

class FoodFightPlayCommand < ActiveModelCommand
  attr_accessor :question_id, :answer_id, :person_id, :on_success, :on_failure

  validates :question_id, numericality: true, presence: true
  validates :answer_id,   numericality: true,
                          presence: true,
                          inclusion: { in: lambda{|o| o.answer_ids } }
  validates :person_id,   numericality: true, presence: true

  delegate :body, to: :question, prefix: :question

  def initialize params={}
    @question_id = params[:question_id]
    @answer_id   = params[:answer_id].to_i
    @on_success = lambda{|a|}
    @on_failure = lambda{|a|}
  end

  def question_repository
    Games::Question.where(game_type: "FoodFight")
  end

  def question
    question_repository.find(question_id)
  end

  def question_answer_repository
    Games::QuestionAnswer.where(question_id: question_id)
  end

  def person_answer_repository
    Games::PersonAnswer
  end

  def game_credit_class
    GameCredit
  end

  def question_answers
    question_answer_repository.all
  end

  def answer_options
    question_answers.map do |qa|
      answer = qa.answer
       AnswerOption.new(answer).tap do |ao|
         ao.chosen  = (answer == chosen_answer)
         ao.correct = (answer == correct_answer)
       end
    end
  end

  def correct_answer
    correct_question_answer = question_answers.detect{|a| a.correct? }
    return nil unless correct_question_answer
    correct_question_answer.answer
  end

  def chosen_answer
    return nil unless chosen_question_answer
    chosen_question_answer.answer
  end

  def chosen_question_answer
    question_answers.detect{|a| a.answer_id == answer_id}
  end

  def answer_ids
    answer_options.map(&:id)
  end

  def correct?
    chosen_answer == correct_answer
  end

  def person_answer_args
    {
      person_id: person_id,
      question_answer_id: chosen_question_answer.id,
      question_id: question_id
    }
  end

  def game_credits
    BigDecimal('0.2')
  end

  def execute!
    return on_failure.call(self) unless valid?
    answer = person_answer_repository.create(person_answer_args)
    credit = game_credit_class.new('FF', person_id)
    credit.increment!(game_credits)
    return on_success.call(self) if answer.valid? && correct?
    return on_failure.call(self)
  end

  class AnswerOption < SimpleDelegator
    attr_accessor :chosen, :correct

    def chosen?
      chosen == true
    end

    def correct?
      correct == true
    end

    def incorrectly_chosen?
      chosen && !correct?
    end

    def html_class
      return 'incorrectly-chosen' if incorrectly_chosen?
      return 'chosen' if chosen?
      return 'correct' if correct?
      return ''
    end
  end
end
