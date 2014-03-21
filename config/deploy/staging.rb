set :branch,    "staging"
set :rails_env, "staging"
role :web,      "mayhemstaging.isotopecloud.com"
role :sidekiq,  "mayhemstaging.isotopecloud.com"
role :app,      "mayhemstaging.isotopecloud.com"
role :db,       "mayhemstaging.isotopecloud.com", primary: true
