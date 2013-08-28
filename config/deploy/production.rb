set :branch,  "origin/master"
role :web,    "192.241.248.83"
role :app,    "192.241.248.83"
role :db,     "192.241.248.83", primary: true
