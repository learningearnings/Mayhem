require_relative '../../test/test_helper_with_rails'

# Spinach && Database Cleaner.
require 'database_cleaner'
require Rails.root.join('features', 'support', 'shared_steps.rb')

DatabaseCleaner.strategy = :transaction
Spinach.hooks.before_scenario do |scenario_data|
  DatabaseCleaner.start
end
Spinach.hooks.after_scenario do |scenario_data|
  DatabaseCleaner.clean
end
Spinach.config.save_and_open_page_on_failure = false
