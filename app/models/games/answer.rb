module Games
  class Answer < ActiveRecord::Base
    self.table_name = :games_answers

    validates :game_type, presence: true
    validates :body, presence: true

    attr_accessible :game_type, :body

    def to_s
      body
    end
  end
end
