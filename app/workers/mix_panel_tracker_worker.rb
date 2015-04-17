class MixPanelTrackerWorker
  include Sidekiq::Worker

  def perform(user_id, event_name, options={})
    Mixpanel::Tracker.new("6980dec826990c22d5bbef3a690bd599").track(user_id, event_name, options) if Rails.env.production?
  end

end
