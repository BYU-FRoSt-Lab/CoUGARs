#!/bin/bash

##########################################################
# SETS UP DOCKER IMAGE REQS ON A NEW RPI
# - Run this script on a newly flashed Raspberry Pi 5.
#   After running it, run "docker.sh" to load in and run
#   the most current image
##########################################################

# Set up udev rules
sudo cp 00-teensy.rules /etc/udev/rules.d/00-teensy.rules

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add user permissions
sudo usermod -aG docker frostlab
sudo su - frostlab

# Set up volumes
mkdir ~/bag
cp -r ~/CougarsSetup/config ~/config