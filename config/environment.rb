# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Leror::Application.initialize!

# Skip version test for imagemagick
RMAGICK_BYPASS_VERSION_TEST = true

ActiveRecord::Base.include_root_in_json = true
