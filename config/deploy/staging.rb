set :branch,  "origin/deploystuff"
role :web,    "mayhemstaging.isotopecloud.com"
role :app,    "mayhemstaging.isotopecloud.com"
role :db,     "mayhemstaging.isotopecloud.com", primary: true
