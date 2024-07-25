#!/bin/bash

#To find CONTROL_ID plug in the teensy that will run the control to the RPI and unplug the other teensy
#Run tycmd list and copy the ID (ie. add 15569680-Teensy Teensy 4.1, you would copy 15569680)

CONTROL_ID="15569680"


#!/bin/bash

# Prompt the user for input
echo "Select an option:"
echo "1) Docker"
echo "2) Local - demo_fins"
echo "3) Local - control.hex"
read -p "Enter your choice (1, 2, or 3): " choice

# Handle the user's input
case $choice in
    1)
        # Option 1 (Docker)
        cd ~/teensy_ws/control/.pio/build/teensy41
        tycmd upload --board $CONTROL_ID firmware.hex
        ;;
    2)
        # Option 2 (Local - demo_fins)
        cd ~/CougarsSetup/config/firmware_options
        tycmd upload --board $CONTROL_ID demo_fins.hex
        ;;
    3)
        # Option 3 (Local - control.hex)
        cd ~/CougarsSetup/config/firmware_options
        tycmd upload --board $CONTROL_ID control.hex
        ;;
    *)
        echo "Invalid choice. Please run the script again and select 1, 2, or 3."
        ;;
esac
