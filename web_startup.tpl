#!/bin/sh

apt-get update -y
apt-get install -y git curl

curl -fsSL https://get.docker.com -o get-docker.sh
sh ./get-docker.sh

git clone https://github.com/msa3dfa/capstone-project.git
cd capstone-project
echo "REDIS_HOST=${ redis_host }\nDB_HOST=${ mysql_host}\nDB_USER=root\nDB_PASSWORD=${ db_password}\nDB_NAME=${ db_name }" > .compose-env
git compose up -d web
