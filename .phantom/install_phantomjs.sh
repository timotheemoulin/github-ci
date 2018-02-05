#!/usr/bin/env bash

set -x

# update package list
apt-get update 

# install required stuff
apt-get install -y --no-install-recommends ca-certificates bzip2 libfontconfig curl markdown 

# get phantomjs binary
mkdir /tmp/phantomjs 
curl -L https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 | tar -xj --strip-components=1 -C /tmp/phantomjs 
mv /tmp/phantomjs/bin/phantomjs /usr/local/bin 

# print the phantomjs version to check if it works
phantomjs --version