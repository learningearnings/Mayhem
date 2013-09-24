# Be sure to restart your server when you modify this file.

# Leror::Application.config.session_store :cookie_store, key: '_leror_session'
Leror::Application.config.session_store :cookie_store, key: '_leror_session', :tld_length => 3, :domain => :all

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# Leror::Application.config.session_store :active_record_store
