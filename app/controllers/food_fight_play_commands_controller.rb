class FoodFightPlayCommandsController < LoggedInController
  def create
    match_setup
    command = FoodFightPlayCommand.new(params[:food_fight_play_command])
    command.person_id = current_person.id
    command.match_id = @match.id
    
    # Set up success / failure callbacks
    command.on_success = method(:on_success)
    command.on_failure = method(:on_failure)
    command.execute!
  end

  def on_success(command, match)
    handle_turn
    redirect_to round_end_games_food_fight_path(:match => @match), flash: { success: "Answered successfully." }
  end

  def on_failure(command)
    flash.now[:error] = "Incorrect answer."
    question_statistics = Games::QuestionStatisticsPresenter.new(command.question)
    #render '/games/food_fights/incorrect', locals: { food_fight_play_command: command, question_statistics: question_statistics }
  end

  def match_setup
    if params[:food_fight_play_command]
      params[:food_fight_play_command][:match_id] = params[:match_id]
      @match = FoodFightMatch.find(params[:match_id])
    else
      @opponent = Person.find(params[:person_id])
      @match = FoodFightMatch.create(:active => true)
      @match.food_fight_players.create(:person_id => current_person.id)
      @match.food_fight_players.create(:person_id => @opponent.id)
      @match
    end
  end

  def handle_turn
    @match.change_turn
    FoodFightMessageStudentCommand.new(:to_id => @match.turn.id, :from_id => @match.player_waiting.id, :body => 'It is your turn in this food fight.  Bring the pain!', :subject => 'Food Fight Match').execute
  end


end
