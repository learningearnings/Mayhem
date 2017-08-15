set :rails_env, "demo"
set :branch,  "demo"
set :unicorn_rack_env, "demo"
role :web,    "18.220.199.6"
role :app,    "18.220.199.6"
role :db,     "18.220.199.6", primary: true
role :sidekiq, "18.220.199.6"
