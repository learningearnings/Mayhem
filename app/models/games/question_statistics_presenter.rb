module Games
  class QuestionStatisticsPresenter
    attr_accessor :question_id

    def initialize(question_id)
      @question_id = question_id
    end

    def number_of_answers
      person_answer_repository.count
    end

    def number_of_correct_answers
      correct_answers.count
    end

    def number_of_incorrect_answers
      number_of_answers - number_of_correct_answers
    end

    def correct_answers
      person_answer_repository.merge(Games::QuestionAnswer.correct)
    end

    def person_answer_repository
      Games::PersonAnswer.where(question_id: @question_id).joins(:question_answer)
    end
  end
end
