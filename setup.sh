#!/bin/bash

##########################################################
# SETS UP DOCKER IMAGE REQS ON A NEW RPI
# - Run this script on a newly flashed Raspberry Pi 5.
#   After running it, run "docker.sh" to load in and run
#   the most current image
##########################################################

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add user permissions
sudo usermod -aG docker frostlab

# Set up volumes
mkdir ~/bag
cp -r ~/CougarsSetup/config ~/config

# Set up udev rules
cd ~/config
bash set_rules.sh

echo "ALERT: Make sure to set the vehicle-specific params in "set_config.sh," "control_id.sh," "sensors_id.sh," and "set_rules.sh" in "~/config" now"
