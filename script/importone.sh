# gzip -dc leafterschools.pg.db.gz | pg_restore -O --clean --dbname=le_development_dhw
rm -rf public/spree/product/*
rm -rf public/system/dragonfly/*
rake le:reload! --trace
rake db:migrate --trace
rake import:fixup import:reset --trace
./processimport.sh schools 215
./processimport.sh classrooms 215
./processimport.sh transactions 215
