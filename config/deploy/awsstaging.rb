set :rails_env, "staging"
set :unicorn_rack_env, "staging"
role :web,      "52.15.59.14"
role :app,      "52.15.59.14"
role :sidekiq,  "52.15.59.14"
role :db,       "52.15.59.14", primary: true
