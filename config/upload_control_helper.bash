#!/bin/bash

<<<<<<< HEAD
#To find CONTROL_ID plug in the teensy that will run the control to the RPI and unplug the other teensy
#Run tycmd list and copy the ID (ie. add 15569680-Teensy Teensy 4.1, you would copy 15569680)

=======
>>>>>>> 437a7a9f4ae42196529a18ea9ca7f5cbdef3563b
CONTROL_ID="15569680"

cd ~/teensy_ws/control/.pio/build/teensy41
tycmd upload --board $CONTROL_ID firmware.hex
