SKIPUNZIP=0

CONFIG="/data/adb/wadb_config"

if [ ! -f "$CONFIG" ]; then
    echo "enabled=on" > "$CONFIG"
    echo "port=5555" >> "$CONFIG"
    ui_print "- Wireless ADB will be enabled on port 5555 after reboot"
else
    PORT=$(grep '^port=' "$CONFIG" | cut -d= -f2)
    ENABLED=$(grep '^enabled=' "$CONFIG" | cut -d= -f2)
    [ -z "$PORT" ] && PORT=5555
    if [ "$ENABLED" = "on" ]; then
        ui_print "- Wireless ADB will be enabled on port $PORT after reboot"
    else
        ui_print "- Wireless ADB is disabled — enable via WebUI"
    fi
fi
