set :rails_env, "staging"
set :unicorn_rack_env, "staging"
role :web,      "107.170.87.36"
role :app,      "107.170.87.36"
role :sidekiq,  "107.170.87.36"
role :db,       "107.170.87.36", primary: true
