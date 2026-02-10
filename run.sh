#!/usr/bin/env sh

get_version() {
    [ -f /etc/earnapp/ver ] && cat /etc/earnapp/ver || echo "unknown"
}

wait_for_status() {
    max_attempts=12
    attempt=0

    while [ "$attempt" -lt "$max_attempts" ]; do
        if [ -f /etc/earnapp/status ] && \
           [ "$(cat /etc/earnapp/status)" = "enabled" ]; then
            return 0
        fi
        attempt=$((attempt + 1))
        sleep 2
    done

    return 1
}

printf "EarnApp v%s\n\n" "$(get_version)"

# Set UUID if provided
if [ -n "$EARNAPP_UUID" ]; then
    printf "%s" "$EARNAPP_UUID" > /etc/earnapp/uuid
fi

# Start in background
earnapp start >/dev/null 2>&1 &

# Wait until enabled
if ! wait_for_status; then
    echo "EarnApp failed to start within expected time."
    exit 1
fi

uuid="$(cat /etc/earnapp/uuid 2>/dev/null || echo "not set")"
status="$(cat /etc/earnapp/status 2>/dev/null || echo "disabled")"

printf "UUID:   %s\n" "$uuid"
printf "Status: %s\n\n" "$status"

earnapp register
earnapp autoupgrade >/dev/null 2>&1 &

exec earnapp run
