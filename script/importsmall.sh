# gzip -dc leafterschools.pg.db.gz | pg_restore -O --clean --dbname=le_development_dhw
#rm -rf public/spree/product/*
#rm -rf public/system/dragonfly/*
#rake le:reload! 
rake db:migrate
xargs --arg-file=smallschoolargs --max-args=10 --max-procs=4 ./processimport.sh schools
xargs --arg-file=smallschoolargs --max-args=10 --max-procs=4  ./processimport.sh classrooms
xargs --arg-file=smallschoolargs --max-args=10 --max-procs=4 ./processimport.sh transactions
