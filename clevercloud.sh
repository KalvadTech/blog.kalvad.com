#!/bin/sh
set -e
set -x
npm install
mkdir -p ./content/adapters/storage
cp -r ./node_modules/ghost-storage-adapter-s3 ./content/adapters/storage/s3
mkdir ghost # create a folder for a new local instance of Ghost
cd ghost
../node_modules/.bin/ghost install local
../node_modules/.bin/ghost stop
# generate production config file
cat <<EOF > config.production.json
{
    "server": {
	"port": 8080,
	"host": "0.0.0.0"
    },
    "database": {
	"client": "mysql",
	"connection": {
	    "host": "$MYSQL_ADDON_HOST",
	    "port": $MYSQL_ADDON_PORT,
	    "user": "$MYSQL_ADDON_USER",
	    "password": "$MYSQL_ADDON_PASSWORD",
	    "database": "$MYSQL_ADDON_DB"
	},
	"pool": {
	    "min": 2,
	    "max": 20
	}
    },
    "mail": {
	"transport": "Direct"
    },
    "process": "local",
    "logging": {
	"level": "debug",
	"transports": [
	    "stdout"
	]
    },
    "paths": {
	"contentPath": "../../../content/"
    }
}
EOF
