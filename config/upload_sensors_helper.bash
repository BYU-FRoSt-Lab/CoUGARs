#!/bin/bash

SENSORS_ID="14484980"

cd ~/teensy_ws/sensors/.pio/build/teensy41
tycmd upload --board $SENSORS_ID firmware.hex
