module Games
  class QuestionAnswer < ActiveRecord::Base
    self.table_name = :games_question_answers
    belongs_to :question, class_name: "Games::Question"
    belongs_to :answer, class_name: "Games::Answer"

    validates :question_id, presence: true, numericality: true
    validates :answer_id, presence: true, numericality: true
    validates :correct, inclusion: { in: [true, false] }

    scope :correct, where(correct: true)

    attr_accessible :question_id, :answer_id, :correct
  end
end
