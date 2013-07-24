module Students
  class HomeController < LoggedInController
    def show
      @products = get_reward_highlights
      @whats_new = whats_new_post
      @featured_activity = featured_activity_post
      @our_sponsor = our_sponsor_post
    end

    private
    def whats_new_post
      fetch_most_recent(WhatsNewPost, "Nothing's new yet")
    end

    def featured_activity_post
      fetch_most_recent(FeaturedActivityPost, "No featured activity yet")
    end

    def our_sponsor_post
      fetch_most_recent(OurSponsorPost, "No sponsor yet")
    end

    def fetch_most_recent(post_type, default_text)
      post_type.published.most_recent.limit(1).first || post_type.new(body: default_text)
    end
  end
end
