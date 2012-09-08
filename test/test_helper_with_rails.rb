require_relative './test_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'action_controller/test_case'
# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f; puts f }

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
