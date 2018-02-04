#!/usr/bin/env bash

docker-compose -f docker-compose.yml build
docker-compose -f docker-compose.yml run phantom .phantom/rasterize.sh README.md .phantom/build/README.pdf
docker-compose -f docker-compose.yml run phantom touch /tmp/foo
docker-compose -f docker-compose.yml run phantom ls -la /tmp/