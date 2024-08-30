#!/bin/bash

##########################################################
# SETS UP DOCKER IMAGE REQS ON A NEW RPI
# - Run this script on a newly flashed Raspberry Pi 5.
#   After running it, run "docker.sh" to load in and run
#   the most current image
##########################################################

# Install Docker if not already installed
if ! [ -x "$(command -v docker)" ]; then
    
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    rm get-docker.sh

    sudo usermod -aG docker frostlab
else

    echo ""
    echo "ALERT: Docker is already installed"
    echo ""
fi

# Set up udev rules
sudo cp /home/frostlab/CougarsSetup/config/local/00-teensy.rules /etc/udev/rules.d/00-teensy.rules
sudo udevadm control --reload-rules
sudo udevadm trigger

# Set up config files
cp ~/CougarsSetup/config/local/chrony.conf /etc/chrony/chrony.conf
cp ~/CougarsSetup/config/local/.tmux.conf ~/.tmux.conf

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
