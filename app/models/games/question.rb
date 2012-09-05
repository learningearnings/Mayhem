module Games
  class Question < ActiveRecord::Base
    self.table_name = :games_questions

    # NOTE: Why do we need this here at all?  Denormalized?
    #validates :number_of_answers, presence: true, numericality: true
    validates :grade, presence: true, numericality: true
    validates :body, presence: true
    validates :game_type, presence: true, inclusion: { in: ["FoodFight"] }
  end
end
