#!/usr/bin/env bash

set -x

docker-compose -f docker-compose.yml build
docker-compose -f docker-compose.yml run phantom .phantom/rasterize.sh README.md .phantom/build/README.pdf
docker-compose -f docker-compose.yml run phantom ls -la .phantom/build