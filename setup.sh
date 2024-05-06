#!/bin/bash

# Set up udev rules
sudo cp 00-teensy.rules /etc/udev/rules.d/00-teensy.rules

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add user permissions
sudo usermod -aG docker frostlab
sudo su -s frostlab