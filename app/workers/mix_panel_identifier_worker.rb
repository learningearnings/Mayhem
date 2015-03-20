class MixPanelIdentifierWorker
  include Sidekiq::Worker
  @token = "6980dec826990c22d5bbef3a690bd599"

  def perform(user_id, options={})
    Mixpanel::Tracker.new(@token).people.set(user_id, options)
  end
end
