module Students
  class HomeController < LoggedInController
    def show
      @products = get_reward_highlights
    end
  end
end
