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
    question_answers.map(&:answer)
  end

  def correct_answer
    question_answers.detect{|a| a.correct? }.answer
  end

  def chosen_answer
    question_answers.detect{|a| a.id == answer_id}.answer
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
end
