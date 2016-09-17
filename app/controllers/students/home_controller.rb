module Students
  class HomeController < LoggedInController
    def show
      @products = get_reward_highlights
      @whats_new = whats_new_post
      @featured_activity = featured_activity_post
      @featured_activity_callout = featured_activity_callout_post
      @our_sponsor = current_school.sponsor_post
      @our_sponsor_callout = our_sponsor_callout_post
      polls = Poll.active.within_grade(current_person.grade)
      polls = polls + Poll.no_min_grade.no_max_grade
      offset = rand(polls.count)
      @poll = polls[offset]
    end

    private
    def whats_new_post
      fetch_most_recent(WhatsNewPost, "Nothing's new yet")
    end

    def featured_activity_post
      fetch_most_recent(FeaturedActivityPost, "No featured activity yet")
    end

    def featured_activity_callout_post
      fetch_most_recent(FeaturedActivityCalloutPost, "")
    end

    def our_sponsor_callout_post
      fetch_most_recent(OurSponsorCalloutPost, "")
    end

    def fetch_most_recent(post_type, default_text)
      post_type.published.most_recent.limit(1).first || post_type.new(body: default_text)
    end
  end
end
