require_relative './test_helper'
require File.expand_path('../../config/environment', __FILE__)
# require 'action_controller/test_case'
require 'rails/test_help'
# Load support files
Dir[Rails.root.join("test/support/**/*.rb")].each { |f| require f }

# Database cleaner.
require 'database_cleaner'
DatabaseCleaner.strategy  = :truncation
DatabaseCleaner.clean

DatabaseCleaner.strategy = :transaction

class MiniTest::Spec
  before :each do
    DatabaseCleaner.start
  end

  after :each do
    DatabaseCleaner.clean
  end
end
