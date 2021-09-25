#!/bin/bash

# update apt repository
sudo apt-get -y update
sudo apt-get -y upgrade

# install stress via apt
sudo apt-get install stress

# Run the stress program and see Kibana update
# Make sure this runs in the background to allow the 
# later commands to be executed
stress --cpu 1 & 

# wait for 2 minutes before killing the process
sleep 120

# find the stress program and kill it
kill $(ps -a | grep stress | awk -F" " '{print $1}')