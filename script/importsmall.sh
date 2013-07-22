#gzip -dc savingit.pg.db.gz | pg_restore -O --clean --dbname=learning_earning_development
rm -rf public/spree/products/*
rm -rf public/system/dragonfly/*
rake le:reload! 
rake db:migrate
rake import:fixup
rake import:reset
#exit
xargs --arg-file=./script/smallschoolargs --max-args=10 --max-procs=4 ./script/processimport.sh schools
xargs --arg-file=./script/smallschoolargs --max-args=10 --max-procs=4  ./script/processimport.sh classrooms
xargs --arg-file=./script/smallschoolargs --max-args=10 --max-procs=4 ./script/processimport.sh transactions
