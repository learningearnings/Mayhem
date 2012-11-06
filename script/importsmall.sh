# gzip -dc leafterschools.pg.db.gz | pg_restore -O --clean --dbname=le_development_dhw
rm -rf public/spree/product/*
rm -rf public/system/dragonfly/*
rake le:reload! 
rake import:fixup
xargs --arg-file=smallschoolargs --max-args=10 --max-procs=5 ./processimport.sh schools
xargs --arg-file=smallschoolargs --max-args=10 --max-procs=5  ./processimport.sh classrooms
xargs --arg-file=smallschoolargs --max-args=10 --max-procs=5 ./processimport.sh transactions
