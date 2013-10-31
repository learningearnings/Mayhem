set :branch,  "master"
role :web,    "192.241.248.83", "192.241.249.30"
role :app,    "192.241.248.83", "192.241.249.30"
role :db,     "192.241.248.83", primary: true
