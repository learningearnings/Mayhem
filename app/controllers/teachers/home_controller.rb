module Teachers
  class HomeController < LoggedInController
    def show
      @new_features = ReleaseNote.published.featured.most_recent
    end
  end
end
