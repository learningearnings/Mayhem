set :branch,  "origin/develop"
role :web,    "mayhemstaging.lemirror.com"
role :app,    "mayhemstaging.lemirror.com"
role :db,     "mayhemstaging.lemirror.com", primary: true
