# On the mainboard tells the stm32 to turn on the modem and DVL

if ["$UCONTROLLER" = "STM" ]; then
    if["$1"="on"]; then
        printf '\$CONTR2,1,5' >> "$UCONTROLLER_SERIAL"
        echo "turned dvl and modem on"
    else
        printf '\$CONTR2,0,5' >> "$UCONTROLLER_SERIAL"
        echo "turned dvl and modem off"
    fi
else
    echo "this script is only valid for the stm-based mainboard, make sure the variable UCONTROLLER is set"
fi