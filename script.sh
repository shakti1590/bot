#!/bin/bash

# install, start and initiate the Mongo dB replica set on your local machine
sudo apt-get update
wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/5.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-5.0.list
sudo apt-get update
sudo apt-get install -y mongodb-org
sudo systemctl start mongod
sudo systemctl enable mongod
# Initialize replica set
mongo --eval "rs.initiate({_id: 'rs0', members: [{_id: 0, host: 'localhost:27017'}, {_id: 1, host: 'localhost:27018'}, {_id: 2, host: 'localhost:27019', arbiterOnly: true}]})"
# Configure WiredTiger cache size
mongo admin --eval "db.runCommand({setParameter: 1, wiredTigerEngineRuntimeConfig: 'cache_size=1GB'})"
# Disable JavaScript execution
mongo admin --eval "db.adminCommand({setParameter: 1, javascriptEnabled: false})"

