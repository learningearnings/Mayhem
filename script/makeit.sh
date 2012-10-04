
pg_dump -O --format=c --clean learning_earning_development | gzip -9 > imported.pg.db.gz
tar -czf images.tgz public/spree/products/* public/system/*
scp imported.pg.db.gz deployer@mayhemstaging.lemirror.com:apps/Mayhem/shared/public/system
scp script/imported.sh.orig deployer@mayhemstaging.lemirror.com:apps/Mayhem/shared/public/system/imported.sh
base64 images.tgz > images.tgz.b64
rm xa?
split -n 20 images.tgz.b64
scp -C xa? deployer@mayhemstaging.lemirror.com:apps/Mayhem/current/public/system

rm images.tgz
rm images.tgz.b64
rm xa?
rm imported.pg.db.gz
