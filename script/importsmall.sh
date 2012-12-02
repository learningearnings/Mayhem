#gzip -dc savingit.pg.db.gz | pg_restore -O --clean --dbname=learning_earning_development
rm -rf public/spree/products/*
rm -rf public/system/dragonfly/*
rake le:reload! 
rake db:migrate
rake import:fixup
rake import:reset
#exit
xargs --arg-file=smallschoolargs --max-args=10 --max-procs=4 ./processimport.sh schools
xargs --arg-file=smallschoolargs --max-args=10 --max-procs=4  ./processimport.sh classrooms
xargs --arg-file=smallschoolargs --max-args=10 --max-procs=4 ./processimport.sh transactions
