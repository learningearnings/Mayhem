class FoodFightPlayCommandsController < LoggedInController
  def create
    command = FoodFightPlayCommand.new(params[:food_fight_play_command])
    command.person_id = current_person.id
    # Set up success / failure callbacks
    command.on_success = method(:on_success)
    command.on_failure = method(:on_failure)
    command.execute!
  end

  def on_success(command)
    redirect_to choose_food_games_food_fight_path, flash: { success: "Answered successfully." }
  end

  def on_failure(command)
    flash.now[:error] = "Incorrect answer."
    question_statistics = Games::QuestionStatisticsPresenter.new(command.question)
    render '/games/food_fights/incorrect', locals: { food_fight_play_command: command, question_statistics: question_statistics }
  end
end
