set :branch,  "production"
set :unicorn_rack_env, "production"
role :web,    "192.241.248.83", "192.241.249.30", "162.243.52.221", "107.170.98.188"
role :sidekiq, "107.170.98.188"
role :app,    "192.241.248.83", "192.241.249.30", "162.243.52.221"
role :db,     "192.241.248.83", primary: true