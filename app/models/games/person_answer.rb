module Games
  class PersonAnswer < ActiveRecord::Base
    self.table_name = :games_person_answers
    attr_accessible :person_id, :question_answer_id, :question_id

    belongs_to :question, class_name: "Games::Question"
    belongs_to :question_answer, class_name: "Games::QuestionAnswer"
    belongs_to :person
  end
end
