#!/bin/bash

SENSORS_ID="ADD HERE"

cd ~/teensy_ws/sensors/.pio/build/teensy41
tycmd upload --board $SENSORS_ID firmware.hex