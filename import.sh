#!/bin/sh

set -e
set -u

DIR="$(dirname $0)"

dc() {
	docker-compose -p vector_tiles -f ${DIR}/docker-compose.yml $*
}

trap 'dc kill ; dc rm -f' EXIT

rm -rf ${DIR}/backups
mkdir -p ${DIR}/backups


dc up -d --build database
sleep 10

# import basiskaart db

dc exec database update-db.sh basiskaart

#dc run --rm importer
dc run importer
