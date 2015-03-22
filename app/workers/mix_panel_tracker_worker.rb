class MixPanelTrackerWorker
  include Sidekiq::Worker
  @token = "6980dec826990c22d5bbef3a690bd599"

  def perform(user_id, event_name, options={})
    Mixpanel::Tracker.new(@token).track(user_id, event_name, options) if Rails.env.production?
  end

end
