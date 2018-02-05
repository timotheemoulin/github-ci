#!/usr/bin/env bash

set -x

apt-get update 
apt-get install -y --no-install-recommends ca-certificates bzip2 libfontconfig curl markdown 

mkdir /tmp/phantomjs 
curl -L https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 | tar -xj --strip-components=1 -C /tmp/phantomjs 
mv /tmp/phantomjs/bin/phantomjs /usr/local/bin 

curl -Lo /tmp/dumb-init.deb https://github.com/Yelp/dumb-init/releases/download/v1.1.3/dumb-init_1.1.3_amd64.deb 
dpkg -i /tmp/dumb-init.deb 

phantomjs --version