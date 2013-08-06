ENV["RAILS_ENV"] = "test"

# Set up simplecov
require 'simplecov'
if ENV["JENKINS"]
  # We use an rcov formatter in the jenkins environment to support code coverage graphs
  require 'simplecov-rcov'
  SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
end
SimpleCov.start 'rails'

require 'minitest/matchers'
require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/reporters'
require "mocha/setup"
require 'valid_attribute'
require 'factory_girl'
require 'bigdecimal'
require 'pry'

require 'mocha'

require 'ostruct'

# Set up minitest
MiniTest::Unit.runner = MiniTest::SuiteRunner.new
MiniTest::Unit.runner.reporters << MiniTest::Reporters::SpecReporter.new
MiniTest::Unit.runner.reporters << MiniTest::Reporters::GuardReporter.new
