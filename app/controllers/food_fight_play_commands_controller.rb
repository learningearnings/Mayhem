class FoodFightPlayCommandsController < LoggedInController
  def create
    match_setup
    command = FoodFightPlayCommand.new(params[:food_fight_play_command])
    command.person_id = current_person.id
    command.match_id = @match.id
    command.school_id = current_school.id
    # Set up success / failure callbacks
    command.on_success = method(:on_success)
    command.on_failure = method(:on_failure)
    command.execute!
  end

  def on_success(command, match, player)
    handle_turn
    redirect_to round_end_games_food_fight_path(:match => match, :player => player), flash: { success: "Answered correctly." }
  end

  def on_failure(command, match, player)
    redirect_to :back, flash: { error: 'Invalid input.' } unless player
    return false unless player
    handle_turn
    flash.now[:error] = "Incorrect answer."
    question_statistics = Games::QuestionStatisticsPresenter.new(command.question)
    @player = player
    @match = match
    redirect_to round_end_games_food_fight_path(:match => match, :player => player), flash: { success: "Answered incorrectly." }
  end

  def match_setup
    @match = FoodFightMatch.find(params[:match_id])
    params[:food_fight_play_command][:match_id] = params[:match_id]
  end

  def handle_turn
    @match.change_turn
    handle_messaging
  end

  def handle_messaging
    if @match.winner?
      GamesMessageStudentCommand.new(:to_id => @match.winner.person.id, :from_id => @match.loser.person.id, :body => "You won the food fight! <a href='/choose_food/#{@match.id}'>Click here to throw food!</a>", :subject => 'Food Fight Match').execute!
      GamesMessageStudentCommand.new(:to_id => @match.loser.person.id, :from_id => @match.winner.person.id, :body => "You lost the food fight. <a href='/rematch/#{@match.winner.person.id}'>Click here for a rematch!</a>", :subject => 'Food Fight Match').execute!
    else
      GamesMessageStudentCommand.new(:to_id => @match.turn.person.id, :from_id => @match.waiting_player.person.id, :body => "It is your turn in this food fight.  Bring the pain! <a href='/continue_match/#{@match.id}'>Click here to get back in the fight!</a>", :subject => 'Food Fight Match').execute!
    end
  end

end
