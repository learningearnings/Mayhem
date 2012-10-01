pg_dump -O --format=c --clean learning_earning_development | gzip -9 > imported.pg.db.gz
tar -czf images.tgz public/spree/products/* public/system/*
scp imported.pg.db.gz deployer@mayhemstaging.lemirror.com:apps/Mayhem/current/public/system
scp script/imported.sh.orig deployer@mayhemstaging.lemirror.com:apps/Mayhem/current/public/system/imported.sh
base64 images.tgz > images.tgz.b64
rm xa?
split -n 20 images.tgz.b64
scp  xaa xab xac xad xae xaf xag xah xai xaj xak xal xam xan xao xap xaq xar xas xat deployer@mayhemstaging.lemirror.com:apps/Mayhem/current/public/system
rm images.tgz
rm xa?
rm imported.pg.db.gz
