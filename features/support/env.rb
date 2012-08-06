require './test/test_helper'

# Spinach && Database Cleaner.
require 'database_cleaner'
DatabaseCleaner.strategy = :transaction
Spinach.hooks.before_scenario do |scenario_data|
  DatabaseCleaner.start
end
Spinach.hooks.after_scenario do |scenario_data|
  DatabaseCleaner.clean
end
Spinach.config.save_and_open_page_on_failure = false
