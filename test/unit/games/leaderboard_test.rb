require 'test_helper'
require_relative '../../../app/models/games/leaderboard'

describe Games::Leaderboard do
  it "knows the #top(n) players and scores for a given game" do
    @leaderboard = Games::Leaderboard.new('FoodFight')
    person_answers = mock "PersonAnswer"
    chain = mock "chain"
    @leaderboard.expects(:person_answer_repository).returns(person_answers)
    person_answers.expects(:select).with("person_id, count(*) as score").returns(chain)
    chain.expects(:joins).with("INNER JOIN games_question_answers ON games_question_answers.id = games_person_answers.question_answer_id").returns(chain)
    chain.expects(:joins).with("INNER JOIN games_questions ON games_question_answers.question_id = games_questions.id").returns(chain)
    chain.expects(:where).with("games_question_answers.correct = true").returns(chain)
    chain.expects(:where).with("games_questions.game_type = ?", 'FoodFight').returns(chain)
    chain.expects(:group).with("person_id").returns(chain)
    chain.expects(:order).with("score DESC").returns(chain)
    chain.expects(:limit).with(10).returns(chain)
    @leaderboard.top(10)
  end
end
