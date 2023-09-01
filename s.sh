wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/5.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-5.0.list
sudo apt-get update
sudo apt-get install -y mongodb-org=5.0.\*
data_dir1="/data/database1"
data_dir2="/data/database2"
data_dir3="/data/database3"
mkdir -p $data_dir1
mkdir -p $data_dir2
mkdir -p $data_dir3
mongod --port 27017 --replSet rs0 --dbpath $data_dir1 --wiredTigerCacheSizeGB 1 --nojavascript &
mongod --port 27018 --replSet rs0 --dbpath $data_dir2 --wiredTigerCacheSizeGB 1 --nojavascript &
mongod --port 27019 --replSet rs0 --dbpath $data_dir3 --wiredTigerCacheSizeGB 1 --nojavascript --arbiter &
mongo --port 27017 --eval "rs.initiate({
  _id: 'rs0',
  members: [
    { _id: 0, host: 'localhost:27017' },
    { _id: 1, host: 'localhost:27018' },
    { _id: 2, host: 'localhost:27019', arbiterOnly: true }
  ]
})"
