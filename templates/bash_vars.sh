#!/bin/bash
# Created by Nelson Durrant, Sep 2024
#
# Defines RPi environment variables for use in Docker bash scripts
# - When setting up a new vehicle, do not directly edit the file in 'templates'; rather the copied file generated by 'setup.sh' in 'config'
# - If you edit this file, you'll need to make sure the copied file in 'config' is updated as well

export NAMESPACE=coug0 # ex. coug0
export VEHICLE_PARAMS_FILE=/home/frostlab/config/vehicle_params.yaml # ex. /home/frostlab/config/vehicle_params.yaml

export GPIO_CHIP=/dev/gpiochip0 # ex. /dev/gpiochip0

# Run "ifconfig eth0 | grep 'inet ' | awk '{print $2}'" from OUTSIDE THE DOCKER CONTAINER and copy that number (ex. "192.168.194.59") here
export STATIC_IP=0