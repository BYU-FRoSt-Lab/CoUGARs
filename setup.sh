#!/bin/bash

##########################################################
# SETS UP DOCKER IMAGE REQS ON A NEW RPI
# - Run this script on a newly flashed Raspberry Pi 5.
#   After running it, run "docker.sh" to load in and run
#   the most current image
##########################################################

case $1 in
    dev)
        echo ""
        echo "ALERT: Building in dev mode (skipping Docker install and udev rules)..."
        echo ""

        ;;
    *)
        echo ""
        echo "ALERT: Building in standard mode (e.g. on a new vehicle)..."
        echo "Build in dev mode by running 'setup.sh dev'"
        echo ""

        # Install Docker
        curl -fsSL https://get.docker.com -o get-docker.sh
        sudo sh get-docker.sh
        rm get-docker.sh

        # Add user permissions
        sudo usermod -aG docker frostlab

        # Set up udev rules
        sudo cp /home/frostlab/CougarsSetup/00-teensy.rules /etc/udev/rules.d/00-teensy.rules
        sudo udevadm control --reload-rules
        sudo udevadm trigger

        ;;
esac

# Copy repos from GitHub
cd ~
git clone https://github.com/snelsondurrant/CougarsRPi.git
git clone https://github.com/snelsondurrant/CougarsTeensy.git

# Set up volumes
mkdir ~/bag
cp -r ~/CougarsSetup/config ~/config

# Install other useful apps
sudo apt install -y vim tmux

echo "ALERT: Make sure to set the vehicle-specific params in "teensy_id.sh" and "vehicle_config.yaml" in "~/config" now"
