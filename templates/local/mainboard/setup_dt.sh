# sets up the device tree for the cm5 based mainboard using the mainboard-overlay file in this directory
# the device tree overlay will be compiled, put in boot/firmware/overlays and added to the config.txt

if cat /proc/device-tree/model | grep -qi compute; then #verifying this is a compute module
    #compile device tree overlay
    dtc -@ -I dts -O dtb -o mainboard-overlay.dtbo mainboard-overlay.dts
    sudo cp mainboard-overlay.dtbo /boot/firmware/overlays/
    #configure config.txt
    if grep -Fxq "dtoverlay=mainboard-overlay" /boot/firmware/config.txt; then
        echo "config seemingly already configured with dt"
    else
        printf "\ndtoverlay=mainboard-overlay" >> /boot/firmware/config.txt
        printf "\nenable_uart=1" >> /boot/firmware/config.txt
        printf "\ndtparam=i2c_arm=on" >> /boot/firmware/config.txt
        echo "config.txt has been configured, restart for changes to take effect"
    fi

else
    echo "this script is intended only for use on the rpi-cm5 based mainboard"
fi