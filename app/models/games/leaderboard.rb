module Games
  class Leaderboard
    def initialize(game_type)
      @game_type = game_type
    end

    def top(limit)
      person_answer_repository.
        select("person_id, count(*) as score").
        joins("INNER JOIN games_question_answers ON games_question_answers.id = games_person_answers.question_answer_id").
        joins("INNER JOIN games_questions ON games_question_answers.question_id = games_questions.id").
        where("games_question_answers.correct = true").
        where("games_questions.game_type = ?", @game_type).
        group("person_id").
        order("score DESC").
        limit(limit)
    end

    protected
    def person_answer_repository
      Games::PersonAnswer
    end
  end
end
