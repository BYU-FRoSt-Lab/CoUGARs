#!/bin/bash

CONTROL_ID="ADD HERE"

cd ~/teensy_ws/control/.pio/build/teensy41
tycmd upload --board $SENSORS_ID firmware.hex