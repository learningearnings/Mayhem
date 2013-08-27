module Games
  class FoodFightsController < LoggedInController
    def show
      leaderboard = Games::Leaderboard.new('FoodFight').top(10)
      render 'show', locals: { current_round: "2012 Round 1", leaderboard: leaderboard }
    end

    def challenge_opponent
      @students = current_school.students - [current_person]
    end

    def play
      match_setup unless @match
      # FIXME: Make this...better
      question = Games::Question.first
      food_fight_play_command = FoodFightPlayCommand.new(question_id: question.id, :match_id => @match.id)
      question_statistics = Games::QuestionStatisticsPresenter.new(question)
      render 'play', locals: { food_fight_play_command: food_fight_play_command, question_statistics: question_statistics }
    end

    def round_end
      @match = FoodFightMatch.find(params[:match])
      @player = FoodFightPlayer.find(params[:player])
      @match.end! if @match.winner?
    end

    def choose_food
      @match = FoodFightMatch.find(params[:match_id])
      @person = @match.loser
      @favorite_foods = current_person.favorite_foods
      @foods = Food.all
    end

    def throw_food
      @food = Food.find(params[:food_id])
      @match = FoodFightMatch.find(params[:match_id])
      @link = FoodPersonLink.create(:food_id => @food.id, :thrown_by_id => current_person.id, :person_id => @match.loser.person.id)
      @match.update_attributes(:food_person_link_id => @link.id)
      FoodFightMessageStudentCommand.new(:to_id => @match.loser.person.id, :from_id => @match.winner.person.id, :body => "#{@match.winner.person.name} has thrown food at you.  <a href='/food_hit/#{@match.id}'>Click here for a rematch!</a>", :subject => 'Food Fight Match').execute!
      redirect_to games_food_fight_path, flash: { success: "Food Thrown!" }
    end

    def food_hit
      @match = FoodFightMatch.find params[:match_id]
      @link = @match.food_person_link
      @food = @link.food
    end

    def continue_match
      @match = FoodFightMatch.find(params[:match_id])
      if @match.turn.person == current_person
        play
      else
        redirect_to games_food_fight_path, flash: { success: "It is not your turn."}
      end
    end

    def rematch
      match_setup
      play
    end

    def match_setup
      if params[:match_id]
        @match = FoodFightMatch.find(params[:match_id])
      else
        @match = FoodFightMatch.create(:active => true)
        @match.food_fight_players.create(:person_id => current_person.id)
        @match.update_attributes(:initiated_by => @match.players.first.id)
        @match.food_fight_players.create(:person_id => params[:person_id])
        @match
      end
    end

  end
end
