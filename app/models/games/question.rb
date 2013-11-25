module Games
  class Question < ActiveRecord::Base
    self.table_name = :games_questions

    belongs_to :category, class_name: "Games::QuestionCategory", foreign_key: :category_id

    # NOTE: Why do we need this here at all?  Denormalized?
    #validates :number_of_answers, presence: true, numericality: true
    validates :grade, presence: true, numericality: true
    validates :body, presence: true
    validates :game_type, presence: true, inclusion: { in: ["FoodFight"] }

    attr_accessible :body, :grade, :game_type

    scope :for_grade, lambda {|grade|  where("grade = ?", grade) }

    def self.random
      order("random()").first
    end
  end
end
