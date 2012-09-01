module Games
  class PersonAnswer < ActiveRecord::Base
    self.table_name = :games_person_answers

    belongs_to :question, class_name: "Games::Question"
    belongs_to :question_answer, class_name: "Games::QuestionAnswer"
    belongs_to :person
  end
end
