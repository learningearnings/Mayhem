source 'http://rubygems.org'

ruby '2.0.0'

# Helper method
def linux_only(require_as)
  RUBY_PLATFORM.include?('linux') && require_as
end

gem 'rake', '~> 10.1.0'
# NOTE: There was a regression in activerecord in 3.2.14 that affects us.  I've
# pinned us to 3.2.13 for now.  It affected the ActivityReport in particular.
gem 'rails', '3.2.13'
gem 'pg', '0.13.2'
gem 'pg_search'
gem 'airbrake'
gem 'newrelic_rpm'
gem 'transaction_retry'
gem 'uuidtools'
gem 'chronic'
gem 'active_model_serializers', '0.8.3'
gem 'bootstrap_forms'
gem 'jwt'
gem 'rack-cors'
gem 'jbuilder'
gem 'ruby-openid', :require => 'openid'
# for importing
#gem 'mysql2'
#gem 'taps'
#gem 'sqlite3'
gem 'faraday'

gem 'modernizr-rails', '~> 2.6.2.3'
gem "webshims-rails", "~> 1.11.1" # if we move to rails 4, please read https://github.com/whatcould/webshims-rails for changes.

gem 'jquery-rails', :github => 'learningearnings/jquery-rails', :branch => 'svgweb-fix'

gem 'jquery-ui-rails'

gem 'activeadmin'
gem 'activeadmin-extra', :github => 'stefanoverna/activeadmin-extra'
gem 'cancan'
gem 'devise'

gem 'whenever', :require => false
gem 'sidekiq'

gem 'therubyracer'

gem 'has_scope'
gem 'responders'
gem 'kaminari'

gem 'googlecharts'
gem 'mixpanel-ruby'

gem 'bootstrap_forms'

# Add native postgres data type suport to activerecord.  Rails 4
# forward-compatible afaik, pretty sure the author's patch made it to rails 4
gem 'postgres_ext'

# Draper provides decorators to help keep your views dry and low on logic
gem 'draper', '0.18.0'

# High Voltage provides drop-in static pages for quick ui mockup
gem 'high_voltage'

# haml is a templating language we use extensively / exclusively on this project
gem 'haml-rails', '~> 0.3.5'
gem 'rdiscount'

# whereabouts is an isotope11 open source gem to provide drop in geolocated polymorphi addresses
gem 'whereabouts', '~> 0.9.0'

# roo handles reading and converting excel files to csv
gem 'iconv'
gem 'roo', '1.12.1'
gem 'spreadsheet'
gem 'rubyzip', '0.9.9'

# Hashie provides lots of nice convenience utilities for working with hashes
gem 'hashie'

# A simple date validator for rails 3
gem 'date_validator'
gem "just-datetime-picker"

# Allows easily modifying models provided earlier in the stack without causing
# any grief
gem 'decorators', '~> 1.0.0'

gem 'ranked-model'
gem 'squeel'
gem 'rack-cache', :require => 'rack/cache'
gem 'dragonfly'
gem 'fog'
gem 'nested_form', :github => 'learningearnings/nested_form'
gem 'simple_form'
gem 'country_select'
gem "ckeditor", '3.7.3'

gem 'redis', '~> 3.3.5'
gem 'redis-classy'
gem 'redis-mutex'

# PDFKit provides an interface to wkhtmltopdf from ruby, and a rack middleware
gem 'pdfkit'

gem 'thor','0.14.6'

# Plutus is what we use to manage our General Ledgers throughout this and other apps
gem 'plutus', :github => 'learningearnings/plutus'

# state_machine is a great gem for building state machines for your ruby objects
gem 'state_machine'

# Spree is a rails-based ecom solution we're using to provide inventory / rewards purchase flow / reporting
# gem 'spree', '~> 1.2.0'
gem 'spree', '1.2.0'
gem 'spree_auth_devise', :github => "learningearnings/spree_auth_devise", :ref => 'eb0f30380dc83390b52939195bf92b4195f5c5a3'

gem 'sinatra'
gem 'spree_multi_domain', :github => 'learningearnings/spree-multi-domain'
gem 'valid_email'
gem 'net-http-persistent'
gem 'rest-client'
# Hope we can use master again soon, they need to accept PR 25 o
group :assets do
  gem 'chosen-rails'
  gem 'sass-rails',   '~> 3.2.6'
  gem 'sass', '~> 3.2.10'
  gem 'compass-rails'
  gem 'animation'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  #gem "compass_twitter_bootstrap", :git => "git://github.com/vwall/compass-twitter-bootstrap.git"
  #gem "compass_twitter_bootstrap", :git => "git://github.com/learningearnings/compass-twitter-bootstrap.git", :tag => "MayhemV1"
  gem "compass_twitter_bootstrap", :github => "learningearnings/compass-twitter-bootstrap"
  gem 'turbo-sprockets-rails3'
  gem "sprockets-image_compressor", "~> 0.2.2"
end

# Use unicorn as the app server
gem 'unicorn'

# To use debugger
#gem 'debugger'

group :development do
  gem 'slack-notifier'
  gem 'quiet_assets'
  gem 'pry', '~> 0.9.10'
  gem 'byebug'
  gem 'unicorn'
  gem 'thin'
  gem 'rack-bug', github: 'learningearnings/rack-bug', branch: 'rails3'
  gem 'letter_opener'
  # Deploy with Capistrano
  gem 'capistrano', '~> 2.15.5'
  gem 'rvm-capistrano', require: false
  gem 'capistrano-unicorn', require: false
  # Generate ERD diagrams from your models
  gem 'rails-erd'
end

group :test do
  gem 'rspec-rails'
  gem 'letter_opener'
  gem 'unicorn'
  #gem 'thin'
  gem 'tconsole'
  gem 'minitest', '~> 3.2.0'
  gem 'minitest-reporters'
  gem 'minitest-matchers', '~> 1.2.0'
  gem 'spinach', '~> 0.5.2'
  gem 'database_cleaner', '~> 1.2.0'
  gem 'spinach-rails', '~> 0.1.7'
  gem 'launchy'
  gem 'capybara'
  gem 'simplecov', '~> 0.6.4'
  gem 'simplecov-rcov', '~> 0.2.3'
  gem 'mocha', '~> 0.14.0', :require => false
  gem 'valid_attribute', :github => 'learningearnings/valid_attribute', :branch => 'minitest-matchers-11'
  gem 'factory_girl_rails'
  gem 'guard', '~> 1.2.3'
  gem 'guard-minitest', '~> 0.5.0'
  gem 'guard-spinach', '~> 0.0.2'
  gem 'faker'
  gem 'spork-rails'
  gem 'timecop'
end

gem "coffee-filter", '~> 0.1.3'

#### Only here for staging deployments ###
gem 'factory_girl_rails'

gem 'sanitizing_bigdecimal'
gem 'httparty'

gem 'nokogiri', '~> 1.5.10'
