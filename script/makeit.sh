pg_dump -O --format=c --clean learning_earning_development | gzip -9 > imported.pg.db.gz
tar -czf imported.tgz imported.pg.db.gz public/spree/products/* public/system/*
rm imported.pg.db.gz
cp script/imported.sh.orig imported.sh
base64 imported.tgz >> imported.sh
echo >> imported.sh
rm imported.sh.gz 2> /dev/null
gzip -9 imported.sh
scp imported.sh.gz deployer@mayhemstaging.lemirror.com:apps/Mayhem/current/public/system
rm imported.sh.gz
