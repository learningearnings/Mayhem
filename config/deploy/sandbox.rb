set :rails_env, "sandbox"
set :branch,  "sandbox"
set :unicorn_rack_env, "sandbox"
role :web,    "162.243.39.36"
role :app,    "162.243.39.36"
role :db,     "162.243.39.36", primary: true
role :sidekiq, "162.243.202.62"