module Games
  class FoodFightsController < LoggedInController
    def show
      leaderboard = Games::Leaderboard.new('FoodFight').top(10)
      render 'show', locals: { current_round: "2012 Round 1", leaderboard: leaderboard }
    end

    def play
      # FIXME: Make this...better
      question = Games::Question.first
      food_fight_play_command = FoodFightPlayCommand.new(question_id: question.id)
      question_statistics = Games::QuestionStatisticsPresenter.new(question)
      render 'play', locals: { food_fight_play_command: food_fight_play_command, question_statistics: question_statistics }
    end

    def choose_food
      @favorite_foods = current_person.favorite_foods
      @foods = Food.all
    end

    def choose_person
      @food = Food.find(params[:food_id])
      @students = current_school.students
    end

    def throw_food
      @food = Food.find(params[:food_id])
      FoodPersonLink.create(:food_id => @food.id, :thrown_by_id => current_person.id, :person_id => params[:person_id])
      redirect_to play_games_food_fight_path, flash: { success: "Food Thrown!" }
    end
 
  end
end
