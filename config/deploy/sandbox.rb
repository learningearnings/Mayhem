set :rails_env, "sandbox"
set :branch,  "sti_beta"
set :unicorn_rack_env, "sandbox"
role :web,    "162.243.39.36"
role :app,    "162.243.39.36"
role :db,     "162.243.39.36", primary: true
