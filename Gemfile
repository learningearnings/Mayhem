source 'https://rubygems.org'

ruby '2.0.0'

# Helper method
def linux_only(require_as)
  RUBY_PLATFORM.include?('linux') && require_as
end

gem 'rake', '~> 10.0.2'
# NOTE: There was a regression in activerecord in 3.2.14 that affects us.  I've
# pinned us to 3.2.13 for now.  It affected the ActivityReport in particular.
gem 'rails', '3.2.13'
gem 'pg', '0.13.2'

# for importing
gem 'mysql2'

gem 'jquery-rails', :github => 'learningearnings/jquery-rails', branch: 'svgweb-fix'

gem 'jquery-ui-rails'

gem 'activeadmin'
gem 'activeadmin-extra', github: 'stefanoverna/activeadmin-extra'
gem 'cancan'
gem 'devise'

gem 'therubyracer'

gem 'has_scope'
gem 'responders'
gem 'kaminari'

gem 'googlecharts'

# Add native postgres data type suport to activerecord.  Rails 4
# forward-compatible afaik, pretty sure the author's patch made it to rails 4
gem 'postgres_ext'

# Draper provides decorators to help keep your views dry and low on logic
gem 'draper', '0.18.0'

# High Voltage provides drop-in static pages for quick ui mockup
gem 'high_voltage'

# haml is a templating language we use extensively / exclusively on this project
gem 'haml-rails', '~> 0.3.5'

# whereabouts is an isotope11 open source gem to provide drop in geolocated polymorphi addresses
gem 'whereabouts', '~> 0.9.0'

# roo handles reading and converting excel files to csv
gem 'roo'

# Hashie provides lots of nice convenience utilities for working with hashes
gem 'hashie'

# A simple date validator for rails 3
gem 'date_validator'

# Allows easily modifying models provided earlier in the stack without causing
# any grief
gem 'decorators', '~> 1.0.0'

gem 'ranked-model'
gem 'squeel'
gem 'rack-cache', :require => 'rack/cache'
gem 'dragonfly'
gem 'nested_form', :github => 'learningearnings/nested_form'
gem 'simple_form'
gem 'country_select'
gem "ckeditor", '3.7.3'

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

gem 'spree_multi_domain', github: 'learningearnings/spree-multi-domain'
# Hope we can use master again soon, they need to accept PR 25 o
group :assets do
  gem 'chosen-rails'
  gem 'sass-rails',   '~> 3.2.3'
  gem 'compass-rails'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  #gem "compass_twitter_bootstrap", :git => "git://github.com/vwall/compass-twitter-bootstrap.git"
  #gem "compass_twitter_bootstrap", :git => "git://github.com/learningearnings/compass-twitter-bootstrap.git", :tag => "MayhemV1"
  gem "compass_twitter_bootstrap", :github => "learningearnings/compass-twitter-bootstrap"
end

# Use unicorn as the app server
gem 'unicorn'

# Deploy with Capistrano
gem 'capistrano', '~> 2.15.5'

# To use debugger
# gem 'debugger'

group :development do
  gem 'pry', '~> 0.9.10'
  gem 'letter_opener'
  gem 'unicorn'
  gem 'thin'
  gem 'rack-bug', github: 'learningearnings/rack-bug', branch: 'rails3'
end

group :test do
  gem 'letter_opener'
  gem 'unicorn'
  gem 'thin'
  gem 'tconsole'
  gem 'minitest', '~> 3.2.0'
  gem 'minitest-reporters', '~> 0.8.0'
  gem 'minitest-matchers', '~> 1.2.0'
  gem 'spinach', '~> 0.5.2'
  gem 'database_cleaner', '~> 0.8.0'
  gem 'spinach-rails', '~> 0.1.7'
  gem 'launchy'
  gem 'capybara'
  gem 'simplecov', '~> 0.6.4'
  gem 'simplecov-rcov', '~> 0.2.3'
  gem 'mocha', '~> 0.14.0', require: false
  gem 'valid_attribute', github: 'learningearnings/valid_attribute', branch: 'minitest-matchers-11'
  gem 'factory_girl_rails'
  gem 'libnotify'
  gem 'rb-fsevent', '~> 0.9.1'
  gem 'rb-inotify', '~> 0.8.8', require: linux_only('rb-inotify')
  gem 'guard', '~> 1.2.3'
  gem 'guard-minitest', '~> 0.5.0'
  gem 'guard-spinach', '~> 0.0.2'
end

gem "coffee-filter", '~> 0.1.3'

#### Only here for staging deploymenbts ###
gem 'factory_girl_rails'
