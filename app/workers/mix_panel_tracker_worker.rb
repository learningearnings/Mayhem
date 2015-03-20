class MixPanelTrackerWorker
  include Sidekiq::Worker
  @token = "6980dec826990c22d5bbef3a690bd599"

  def perform(user_id, event_name, options={})
    Mixpanel::Tracker.new(@token).track(user_id, event_name, options)
  end

  def identify user_id, options={}
    tracker = Mixpanel::Tracker.new(@token)
    tracker.people.set(user_id, options)
  end
  
  #def track user_id, event_name, options={}
  #  tracker = Mixpanel::Tracker.new(@token)
  #  tracker.track(user_id, event_name, options)
  #end
end
