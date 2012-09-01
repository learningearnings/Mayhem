class FoodFightPlayCommand < ActiveModelCommand
  attr_accessor :question_id, :answer_id, :person_id, :on_success, :on_failure

  validates :question_id, numericality: true, presence: true
  validates :answer_id,   numericality: true, presence: true
  validates :person_id,   numericality: true, presence: true
  validates :answer_id,   inclusion: { in: lambda{|o| o.answer_ids } }

  delegate :body, to: :question, prefix: :question

  def initialize params={}
    @question_id = params[:question_id]
    @answer_id   = params[:answer_id].to_i
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
    chosen_question_answer = question_answers.detect{|a| a.id == answer_id}
    return nil unless chosen_question_answer
    chosen_question_answer.answer
  end

  def answer_ids
    answer_options.map(&:id)
  end

  def correct?
    chosen_answer == correct_answer
  end

  def execute!
    return on_success.call(self) if valid? && correct?
    # TODO: Actually execute stuff.
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
