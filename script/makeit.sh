pg_dump -O --format=c --clean learning_earning_development | gzip -9 > imported.pg.db.gz
tar -czf images.tgz public/spree/products/* public/system/*
scp imported.pg.db.gz deployer@mayhemstaging.lemirror.com:apps/Mayhem/current/public/system
scp script/imported.sh.orig deployer@mayhemstaging.lemirror.com:apps/Mayhem/current/public/system/imported.sh
base64 images.tgz > images.tgz.b64
rm xa?
split -n 20 images.tgz.b64
scp xaa deployer@mayhemstaging.lemirror.com:apps/Mayhem/current/public/system
sleep 1
scp xaa deployer@mayhemstaging.lemirror.com:apps/Mayhem/current/public/system
sleep 1
scp xab deployer@mayhemstaging.lemirror.com:apps/Mayhem/current/public/system
sleep 1
scp xac deployer@mayhemstaging.lemirror.com:apps/Mayhem/current/public/system
sleep 1
scp xad deployer@mayhemstaging.lemirror.com:apps/Mayhem/current/public/system
sleep 1
scp xae deployer@mayhemstaging.lemirror.com:apps/Mayhem/current/public/system
sleep 1
scp xaf deployer@mayhemstaging.lemirror.com:apps/Mayhem/current/public/system
sleep 1
scp xag deployer@mayhemstaging.lemirror.com:apps/Mayhem/current/public/system
sleep 1
scp xah deployer@mayhemstaging.lemirror.com:apps/Mayhem/current/public/system
sleep 1
scp xai deployer@mayhemstaging.lemirror.com:apps/Mayhem/current/public/system
sleep 1
scp xaj deployer@mayhemstaging.lemirror.com:apps/Mayhem/current/public/system
sleep 1
scp xak deployer@mayhemstaging.lemirror.com:apps/Mayhem/current/public/system
sleep 1
scp xal deployer@mayhemstaging.lemirror.com:apps/Mayhem/current/public/system
sleep 1
scp xam deployer@mayhemstaging.lemirror.com:apps/Mayhem/current/public/system
sleep 1
scp xan deployer@mayhemstaging.lemirror.com:apps/Mayhem/current/public/system
sleep 1
scp xao deployer@mayhemstaging.lemirror.com:apps/Mayhem/current/public/system
sleep 1
scp xap deployer@mayhemstaging.lemirror.com:apps/Mayhem/current/public/system
sleep 1
scp xaq deployer@mayhemstaging.lemirror.com:apps/Mayhem/current/public/system
sleep 1
scp xar deployer@mayhemstaging.lemirror.com:apps/Mayhem/current/public/system
sleep 1
scp xas deployer@mayhemstaging.lemirror.com:apps/Mayhem/current/public/system
sleep 1
scp xat deployer@mayhemstaging.lemirror.com:apps/Mayhem/current/public/system

rm images.tgz
rm xa?
rm imported.pg.db.gz
