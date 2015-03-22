class MixPanelIdentifierWorker
  include Sidekiq::Worker

  def perform(user_id, options={})
    Mixpanel::Tracker.new("6980dec826990c22d5bbef3a690bd599").people.set(user_id, options) if Rails.env.production?
  end
end