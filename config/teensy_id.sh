#!/bin/bash

##########################################################
# DEFINES THE TEENSY IDS FOR BASH SCRIPT USAGE
# - When setting up a new vehicle, do not directly edit
#   the file in ~/CougarsSetup/config; rather edit the
#   copied file generated by "setup.sh" in ~/config (to 
#   add SENSORS_ID, etc.)
##########################################################

# To find the CONTROL_ID, power on the control Teensy and power off the sensors Teensy
# then run "tycmd list" and copy the listed numeric ID (ex. "15569680")
CONTROL_ID="ADD HERE"

# To find the SENSORS_ID, power on the control Teensy and power off the sensors Teensy
# then run "tycmd list" and copy the listed numeric ID (ex. "15569680")
SENSORS_ID="ADD HERE"
