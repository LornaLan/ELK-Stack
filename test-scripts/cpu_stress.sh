#!/bin/bash

# update apt repository
sudo apt-get -y update
sudo apt-get -y upgrade

# install stress via apt
sudo apt-get install stress

# Run the stress program and see Kibana update
stress --cpu 1

# wait for 2 minutes before killing the process
sleep 120

# find the stress program and kill it
prog_id=$(ps -a | grep stress | awk -F" " 'print $1}')
kill $prog_id