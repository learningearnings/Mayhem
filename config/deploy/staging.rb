set :branch,    "feature/add_oboe"
set :rails_env, "staging"
role :web,      "mayhemstaging.isotopecloud.com"
role :app,      "mayhemstaging.isotopecloud.com"
role :db,       "mayhemstaging.isotopecloud.com", primary: true
