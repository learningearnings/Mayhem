# Set up simplecov
require 'simplecov'
ENV["RAILS_ENV"] = "test"
SimpleCov.start 'rails'

require File.expand_path('../../config/environment', __FILE__)

require 'minitest/matchers'
require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/reporters'
require 'valid_attribute'

require 'mocha'

require 'ostruct'

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# Set up minitest
MiniTest::Unit.runner = MiniTest::SuiteRunner.new
MiniTest::Unit.runner.reporters << MiniTest::Reporters::SpecReporter.new
