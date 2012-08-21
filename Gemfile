source 'https://rubygems.org'

gem 'rails', '~> 3.2.6'
gem 'sqlite3'
gem 'pg'

gem 'jquery-rails'

gem 'activeadmin'
gem 'cancan'
gem 'devise'

gem 'therubyracer'
gem 'compass-rails'

gem 'has_scope'
gem 'responders'

# Draper provides decorators to help keep your views dry and low on logic
gem 'draper'

# High Voltage provides drop-in static pages for quick ui mockup
gem 'high_voltage'

# haml is a templating language we use extensively / exclusively on this project
gem 'haml-rails'

# whereabouts is an isotope11 open source gem to provide drop in geolocated polymorphi addresses
gem 'whereabouts', '~> 0.9.0'

gem 'ranked-model'
gem 'squeel'
gem 'rack-cache', :require => 'rack/cache'
gem 'dragonfly'
gem 'nested_form', :git => 'git://github.com/ryanb/nested_form.git'
gem 'simple_form'
gem 'country_select'

# PDFKit provides an interface to wkhtmltopdf from ruby, and a rack middleware
gem 'pdfkit'

gem 'thor','0.14.6'

# Plutus is what we use to manage our General Ledgers throughout this and other apps
gem 'plutus'

# state_machine is a great gem for building state machines for your ruby objects
gem 'state_machine'

# Spree is a rails-based ecom solution we're using to provide inventory / rewards purchase flow / reporting
gem 'spree', '1.1.3'
gem 'spree_multi_domain', :git =>  "git://github.com/johndavid400/spree-multi-domain.git", :branch => "master"

group :assets do
  gem 'compass_twitter_bootstrap', :git => 'git://github.com/vwall/compass-twitter-bootstrap.git'
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem "compass_twitter_bootstrap", :git => "git://github.com/vwall/compass-twitter-bootstrap.git"
end

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'

group :development, :test do
  gem 'pry', '~> 0.9.10'
  gem 'letter_opener'
  gem 'guard', '~> 1.2.3'
  gem 'guard-minitest', '~> 0.5.0'
  gem 'guard-spinach', '~> 0.0.2'
  gem 'unicorn'
  gem 'libnotify'
end

group :test do
  gem 'minitest', '~> 3.2.0'
  gem 'minitest-reporters', '~> 0.8.0'
  gem 'minitest-matchers', '~> 1.2.0'
  gem 'spinach', '~> 0.5.2'
  gem 'database_cleaner', '~> 0.8.0'
  gem 'spinach-rails', '~> 0.1.7'
  gem 'simplecov', '~> 0.6.4'
  gem 'simplecov-rcov', '~> 0.2.3'
  gem 'mocha', '~> 0.12.1'
  gem 'valid_attribute', git: 'git://github.com/wojtekmach/valid_attribute.git', branch: 'minitest-matchers-11'
  gem 'factory_girl_rails'
end
