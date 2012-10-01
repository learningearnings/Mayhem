pg_dump -O --format=c --clean learning_earning_development | gzip -9 > imported.pg.db.gz
tar -czf images.tgz public/spree/products/* public/system/*
scp imported.pg.db.gz deployer@mayhemstaging.lemirror.com:apps/Mayhem/current/public/system
scp script/imported.sh.orig deployer@mayhemstaging.lemirror.com:apps/Mayhem/current/public/system/imported.sh
base64 images.tgz > images.tgz.b64
scp xaa deployer@mayhemstaging.lemirror.com:apps/Mayhem/current/public/system
scp xab deployer@mayhemstaging.lemirror.com:apps/Mayhem/current/public/system
scp xac deployer@mayhemstaging.lemirror.com:apps/Mayhem/current/public/system
scp xad deployer@mayhemstaging.lemirror.com:apps/Mayhem/current/public/system
scp xae deployer@mayhemstaging.lemirror.com:apps/Mayhem/current/public/system
scp xaf deployer@mayhemstaging.lemirror.com:apps/Mayhem/current/public/system
scp xag deployer@mayhemstaging.lemirror.com:apps/Mayhem/current/public/system
scp xah deployer@mayhemstaging.lemirror.com:apps/Mayhem/current/public/system
scp xai deployer@mayhemstaging.lemirror.com:apps/Mayhem/current/public/system
scp xaj deployer@mayhemstaging.lemirror.com:apps/Mayhem/current/public/system
scp xak deployer@mayhemstaging.lemirror.com:apps/Mayhem/current/public/system
scp xal deployer@mayhemstaging.lemirror.com:apps/Mayhem/current/public/system
scp xam deployer@mayhemstaging.lemirror.com:apps/Mayhem/current/public/system
scp xan deployer@mayhemstaging.lemirror.com:apps/Mayhem/current/public/system
scp xao deployer@mayhemstaging.lemirror.com:apps/Mayhem/current/public/system
scp xap deployer@mayhemstaging.lemirror.com:apps/Mayhem/current/public/system
scp xaq deployer@mayhemstaging.lemirror.com:apps/Mayhem/current/public/system
scp xar deployer@mayhemstaging.lemirror.com:apps/Mayhem/current/public/system
scp xas deployer@mayhemstaging.lemirror.com:apps/Mayhem/current/public/system
scp xat deployer@mayhemstaging.lemirror.com:apps/Mayhem/current/public/system
rm images.tgz
rm xa?
rm imported.pg.db.gz
