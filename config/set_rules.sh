#!/bin/bash

##########################################################
# UPDATES THE TEENSY UDEV RULES
# - Run this script after editing and saving the
#   "99-teensy.rules" file
##########################################################

sudo cp ~/config/00-teensy.rules /etc/udev/rules.d/00-teensy.rules
sudo cp ~/config/99-teensy.rules /etc/udev/rules.d/99-teensy.rules

sudo udevadm control --reload-rules
sudo udevadm trigger
