module Games
  class FoodFightsController < LoggedInController
    def show
      render 'show', locals: { current_round: "2012 Round 1" }
    end

    def play
      # FIXME: Make this...better
      question = Games::Question.first
      food_fight_play_command = FoodFightPlayCommand.new(question_id: question.id)
      render 'play', locals: { food_fight_play_command: food_fight_play_command }
    end
  end
end
