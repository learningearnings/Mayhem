set :rails_env, "demo"
set :branch,  "sti_beta"
set :unicorn_rack_env, "demo"
role :web,    "162.243.9.20"
role :app,    "162.243.9.20"
role :db,     "162.243.9.20", primary: true
