#!/bin/bash

#To find CONTROL_ID plug in the teensy that will run the control to the RPI and unplug the other teensy
#Run tycmd list and copy the ID (ie. add 15569680-Teensy Teensy 4.1, you would copy 15569680)

CONTROL_ID="ADD HERE"

cd ~/teensy_ws/control/.pio/build/teensy41
tycmd upload --board $CONTROL_ID firmware.hex
