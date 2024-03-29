#!/usr/bin/env bash

#
# install ruby
#

sudo apt update
sudo apt install -y ruby-full ruby-bundler build-essential
sudo ruby -v
sudo bundler -v

#
# install mongodb
#

sudo rm /etc/apt/sources.list.d/mongodb*.list
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv E52529D4
sudo bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.0 multiverse" > /etc/apt/sources.list.d/mongodb-org-4.0.list'
sudo apt update
sudo apt install -y mongodb-org
sudo systemctl enable mongod.service
sudo systemctl start mongod.service
mongo --version
systemctl status mongod.service

#
# deplay test app
#

cd ~/
git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install
puma -d
ps xa | grep puma
