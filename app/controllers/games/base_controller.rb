class Games::BaseController < LoggedInController
  def show
    @products = get_reward_highlights
  end
end
