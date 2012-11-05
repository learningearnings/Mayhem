# gzip -dc leafterschools.pg.db.gz | pg_restore -O --clean --dbname=le_development_dhw
rm -rf public/spree/product/*
rm -rf public/system/dragonfly/*
rake le:reload! --trace
rake import:fixup --trace
xargs --arg-file=tinyschoolargs --max-args=2 --max-procs=3 ./processimport.sh schools
xargs --arg-file=tinyschoolargs --max-args=2 --max-procs=3  ./processimport.sh classrooms
xargs --arg-file=tinyschoolargs --max-args=2 --max-procs=3 ./processimport.sh transactions
