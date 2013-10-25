module Games
  class QuestionCategory < ActiveRecord::Base
    self.table_name = "games_question_categories"

    attr_accessible :subject
  end
end
