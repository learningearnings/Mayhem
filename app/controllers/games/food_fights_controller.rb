module Games
  class FoodFightsController < LoggedInController
    def show
      render 'show', locals: { current_round: "2012 Round 1" }
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

    def choose_school
      @food = Food.find(params[:food_id])
      @schools = School.all
    end

    def throw_food
      @school = School.find(params[:school_id])
      @food = Food.find(params[:food_id])
      FoodSchoolLink.create(:food_id => @food.id, :school_id => @school.id)
      PersonFoodSchoolLink.create(:person_id => current_person.id, :school_id => @school.id)
      PersonFoodLink.create(:person_id => current_person.id, :food_id => @food.id)
      redirect_to play_games_food_fight_path, flash: { success: "Food Thrown!" }
    end
 
  end
end
