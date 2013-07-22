#!/bin/bash

pg_dump -O --format=c --clean learning_earning_development | gzip -9 > imported.pg.db.gz
tar -czf images.tgz public/spree/products/* public/system/*
scp imported.pg.db.gz deployer@mayhemstaging.lemirror.com:apps/Mayhem/shared/system
scp script/imported.sh.orig deployer@mayhemstaging.lemirror.com:apps/Mayhem/shared/system/imported.sh
scp images.tgz deployer@mayhemstaging.lemirror.com:apps/Mayhem/shared/system
rm images.tgz
rm imported.pg.db.gz
