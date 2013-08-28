#!/bin/bash
adduser deployer
apt-get install git-core build-essential gawk libreadline6-dev zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 autoconf libgdbm-dev libncurses5-dev automake libtool bison pkg-config libffi-dev libxslt-dev libpq-dev nginx
rm /etc/nginx/sites-available/default /etc/nginx/sites-available/mayhem /etc/nginx/sites-available/mayhem-ssl
wget https://gist.github.com/knewter/dc77eaabe06e6e367de4/raw/f0676a2fa1bcb96b2a37dbbeb9f66c630eff1ccc/mayhem -P /etc/nginx/sites-available/
wget https://gist.github.com/knewter/dc77eaabe06e6e367de4/raw/f0676a2fa1bcb96b2a37dbbeb9f66c630eff1ccc/mayhem-ssl -P /etc/nginx/sites-available/
ln -sf /etc/nginx/sites-available/mayhem-ssl /etc/nginx/sites-enabled/
