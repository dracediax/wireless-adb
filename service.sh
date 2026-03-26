#!/system/bin/sh
MODDIR=${0%/*}
CONFIG="/data/adb/wadb_config"
LOGFILE="$MODDIR/debug.log"

echo "=== Wireless ADB Boot ===" > "$LOGFILE"
echo "Date: $(date)" >> "$LOGFILE"

# Wait for boot
while [ "$(getprop sys.boot_completed)" != "1" ]; do sleep 2; done
sleep 5

ENABLED="on"
PORT="5555"

if [ -f "$CONFIG" ]; then
    ENABLED=$(grep '^enabled=' "$CONFIG" | cut -d= -f2)
    PORT=$(grep '^port=' "$CONFIG" | cut -d= -f2)
    [ -z "$PORT" ] && PORT=5555
    [ -z "$ENABLED" ] && ENABLED="on"
fi

echo "enabled=$ENABLED" >> "$LOGFILE"
echo "port=$PORT" >> "$LOGFILE"

if [ "$ENABLED" = "on" ]; then
    setprop service.adb.tcp.port "$PORT"
    stop adbd
    start adbd
    echo "adbd restarted on port $PORT" >> "$LOGFILE"

    # Get device IP for log
    IP=$(ip route get 1.1.1.1 2>/dev/null | grep -o 'src [0-9.]*' | cut -d' ' -f2)
    echo "ip=$IP" >> "$LOGFILE"
    echo "connect=$IP:$PORT" >> "$LOGFILE"

    # Send notification
    su 2000 -c "/system/bin/cmd notification post -S bigtext -t 'Wireless ADB Active' wadb 'Connect: $IP:$PORT'" >/dev/null 2>&1
else
    echo "wireless ADB disabled — skipping" >> "$LOGFILE"
fi
