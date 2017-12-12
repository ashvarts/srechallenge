#!/usr/bin/env bash

curl -L https://www.opscode.com/chef/install.sh | sudo bash

sudo chef-solo -c /home/ubuntu/chef/solo.rb -o srechallenge