#!/bin/bash

<<<<<<< HEAD
#To find SENSORS_ID plug in the teensy that will run the control to the RPI and unplug the other teensy
#Run tycmd list and copy the ID (ie. add 15569680-Teensy Teensy 4.1, you would copy 15569680)

SENSORS_ID="14484980"

cd ~/teensy_ws/sensors/.pio/build/teensy41
tycmd upload --board $SENSORS_ID firmware.hex
