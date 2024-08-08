#!/bin/bash

# Set up volumes
cp -r ~/CougarsSetup/config ~/config

# Set up udev rules
cd ~/config
bash set_rules.sh

echo "ALERT: Make sure to set the vehicle-specific params in "set_config.sh," "control_id.sh," "sensors_id.sh," and "set_rules.sh" in "~/config" now"

# Add user permissions
sudo usermod -aG docker frostlab