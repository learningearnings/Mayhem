# Configure Spree Preferences
# 
# Note: Initializing preferences available within the Admin will overwrite any changes that were made through the user interface when you restart.
#       If you would like users to be able to update a setting with the Admin it should NOT be set here.
#
# In order to initialize a setting do: 
# config.setting_name = 'new value'
Spree.config do |config|
  # Example:
  # Uncomment to override the default site name.
  config.site_name = "Learning Earnings Store"
  config.auto_capture = true
  config.layout = 'application'
  config.searcher_class = Spree::Search::Filter

end

module SpreeOverrideEngine
  class Engine < Rails::Engine
    config.after_initialize do
      Rails.application.config.spree.payment_methods = [Spree::Gateway::LearningEarnings]
    end
  end
end
