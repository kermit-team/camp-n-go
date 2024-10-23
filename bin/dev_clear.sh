#!/bin/sh
set -e

docker compose stop
docker compose rm -svf
docker volume list | egrep 'camp-n-go.+data' | awk '{ print $2 }' | xargs docker volume rm
docker images | egrep 'camp-n-go.+' | awk '{ print $1 }' | xargs docker rmi -f || true

rm envs/.backend.env
rm envs/.database.env
rm envs/.frontend.env
