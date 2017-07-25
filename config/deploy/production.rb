set :branch,  "production"
set :unicorn_rack_env, "production"
role :web,    "192.241.249.30", "107.170.98.188"#, "192.241.248.83", "162.243.52.221"
role :sidekiq, "107.170.98.188"
role :app,    "192.241.249.30"#, "192.241.248.83", "162.243.52.221"
role :db,     "192.241.249.30", primary: true
