#!/usr/bin/env bash

#
# deplay test app
#

cd ~/
git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install
