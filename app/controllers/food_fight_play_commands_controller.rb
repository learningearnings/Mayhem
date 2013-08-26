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

  def on_success(command, match, player)
    handle_turn
    redirect_to round_end_games_food_fight_path(:match => match, :player => player), flash: { success: "Answered successfully." }
  end

  def on_failure(command, match, player)
    handle_turn
    flash.now[:error] = "Incorrect answer."
    question_statistics = Games::QuestionStatisticsPresenter.new(command.question)
    @player = player
    @match = match
    redirect_to round_end_games_food_fight_path(:match => match, :player => player), flash: { success: "Answered successfully." }
  end

  def match_setup
    if params[:food_fight_play_command]
      params[:food_fight_play_command][:match_id] = params[:match_id]
      @match = FoodFightMatch.find(params[:match_id])
    else
      @opponent = Person.find(params[:person_id])
      @match = FoodFightMatch.create(:active => true, :initiated_by => current_person.id)
      @match.food_fight_players.create(:person_id => current_person.id)
      @match.update_attributes(:initiated_by => @match.players.first.id)
      @match.food_fight_players.create(:person_id => @opponent.id)
      @match
    end
  end

  def handle_turn
    @match.change_turn
    handle_messaging
  end

  def handle_messaging
    if @match.winner?
      FoodFightMessageStudentCommand.new(:to_id => @match.winner.person.id, :from_id => @match.loser.person.id, :body => "You won the food fight! <a href='/games/food_fight/throw_food/#{@match}'>Click here to throw food!</a>", :subject => 'Food Fight Match').execute!
      FoodFightMessageStudentCommand.new(:to_id => @match.loser.person.id, :from_id => @match.winner.person.id, :body => "You lost the food fight. <a href='/rematch/#{@match.winner.id}'>Click here for a rematch!</a>", :subject => 'Food Fight Match').execute!
    else
      FoodFightMessageStudentCommand.new(:to_id => @match.turn.person.id, :from_id => @match.waiting_player.person.id, :body => "It is your turn in this food fight.  Bring the pain! <a href='/continue_match/#{@match.id}'>Click here to get back in the fight!</a>", :subject => 'Food Fight Match').execute!
    end

  end

end
