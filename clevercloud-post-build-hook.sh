#!/bin/sh
set -e
set -x

# Add S3 Storage
mkdir -p ./content/adapters/storage
cp -r ./node_modules/ghost-storage-adapter-s3 ./content/adapters/storage/s3
mkdir ghost # create a folder for a new local instance of Ghost
cd ghost
../node_modules/.bin/ghost install local
../node_modules/.bin/ghost stop
# generate config file
cd ..
../clevercloud-pre-run-hook.sh
