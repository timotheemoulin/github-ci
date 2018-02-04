#!/usr/bin/env bash
docker-compose -f docker-compose.yml build
docker-compose -f docker-compose.yml run phantom /data/.phantom/rasterize.sh /data/README.md /data/.phantom/build/README.pdf
docker-compose -f docker-compose.yml run phantom touch /tmp/foo
docker-compose -f docker-compose.yml run phantom ls -la /tmp/