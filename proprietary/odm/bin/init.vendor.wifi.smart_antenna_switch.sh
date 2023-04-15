
config="$1"

function initial() {
    mode="$1"
    if [ "$mode" -eq "5" ]; then
        echo `/vendor/bin/athdiag --set --address=0x1038004 --arena=0xc --value=0x240`
    else
        echo `vendor_cmd_tool -f /vendor/etc/wifi/vendor_cmd.xml -i wlan0 --START_CMD --GPIO_CONFIG --GPIO_COMMAND 0 --GPIO_PINNUM 56 --GPIO_PULL_TYPE 2 --GPIO_INTR 3 --GPIO_DIR 1 --GPIO_MUX_CONFIG 15 --END_CMD`
    fi
}

function swithToPrimaryAnt() {
    mode="$1"
    if [ "$mode" -eq "5" ]; then
        echo `/vendor/bin/athdiag --set --address=0x1038004 --arena=0xc --value=0x0`
    else
        echo `vendor_cmd_tool -f /vendor/etc/wifi/vendor_cmd.xml -i wlan0 --START_CMD --GPIO_CONFIG --GPIO_COMMAND 1 --GPIO_PINNUM 56 --GPIO_VALUE 0 --END_CMD`
    fi
}

function swithToSecondAnt() {
    mode="$1"
    if [ "$mode" -eq "5" ]; then
        echo `/vendor/bin/athdiag --set --address=0x1038004 --arena=0xc --value=0x2`
    else
        echo `vendor_cmd_tool -f /vendor/etc/wifi/vendor_cmd.xml -i wlan0 --START_CMD --GPIO_CONFIG --GPIO_COMMAND 1 --GPIO_PINNUM 56 --GPIO_VALUE 1 --END_CMD`
    fi
}

con_mode=$(cat /sys/module/qca6490/parameters/con_mode)
echo "$con_mode"
case "$config" in
    "initial")
    cmd=$(initial "$con_mode")
    ;;
    "primaryOne")
    cmd=$(swithToPrimaryAnt "$con_mode")
    ;;
    "secondaryOne")
    cmd=$(swithToSecondAnt "$con_mode")
    ;;
esac
echo "$cmd"