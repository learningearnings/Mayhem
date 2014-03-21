set :rails_env, "qa"
set :branch,  "sti_beta"
role :web,    "162.243.202.62"
role :app,    "162.243.202.62"
role :db,     "162.243.202.62", primary: true
