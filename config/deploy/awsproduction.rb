set :branch,  "production"
set :unicorn_rack_env, "production"
role :web,    "52.14.111.36", "52.14.133.78", "52.14.243.83","13.58.95.55"
role :sidekiq, "13.58.95.55"
role :app,    "52.14.111.36", "52.14.133.78", "52.14.243.83"
role :db,     "52.14.111.36", primary: true
