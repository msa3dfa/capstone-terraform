#!/bin/sh

apt-get update -y
apt-get install -y git curl

curl -fsSL https://get.docker.com -o get-docker.sh
sh ./get-docker.sh

git clone https://github.com/msa3dfa/capstone-project.git
cd capstone-project
echo "MYSQL_ROOT_PASSWORD=${ root_password }\nMYSQL_DATABASE=${ database }" > .compose-env
docker compose up -d mysql
