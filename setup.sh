#!/bin/bash

##########################################################
# SETS UP DOCKER IMAGE REQS ON A NEW RPI
# - Run this script on a newly flashed Raspberry Pi 5.
#   After running it, run "docker.sh" to load in and run
#   the most current image
##########################################################

echo "Make sure to add the serial numbers of the teensys to the 99-teensy.rules file"
echo "Enter the same serial numbers into the upload helper bash scripts in the config folder"
echo "You can find the serial numbers by running: tycmd list"
# Set up udev rules
sudo cp 00-teensy.rules /etc/udev/rules.d/00-teensy.rules
sudo cp 99-teensy.rules /etc/udev/rules.d/99-teensy.rules

sudo udevadm control --reload-rules
sudo udevadm trigger

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add user permissions
sudo usermod -aG docker frostlab
sudo su - frostlab

# Set up volumes
mkdir ~/bag
cp -r ~/CougarsSetup/config ~/config