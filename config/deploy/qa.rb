set :rails_env, "qa"
set :branch,  "sandbox"
role :web,    "162.243.202.62"
role :app,    "162.243.202.62"
role :db,     "162.243.202.62", primary: true
