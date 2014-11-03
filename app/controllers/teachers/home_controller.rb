module Teachers
  class HomeController < LoggedInController
    def show
      @features = Feature.active
    end
  end
end
