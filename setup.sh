#!/bin/bash

# Set up udev rules
# sudo cp 00-teensy.rules /etc/udev/rules.d/00-teensy.rules

# Make local log directory
# mkdir ~/bag/

# Install Docker
# curl -fsSL https://get.docker.com -o get-docker.sh
# sudo sh get-docker.sh

# Pull latest version of Docker repo
sudo usermod -aG docker frostlab
su -s frostlab
docker pull snelsondurrant/cougars:latest