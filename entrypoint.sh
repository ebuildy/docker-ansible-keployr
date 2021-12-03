#!/bin/sh

if [[ -n "$KEPLOYR_USER" ]]; then
    echo "Create user $KEPLOYR_USER"
    adduser -u $KEPLOYR_USER_UID $KEPLOYR_USER || true

    MY_USER=$(getent passwd $KEPLOYR_USER_UID | cut -d: -f1)

    exec su ${MY_USER} -c "$@"
else
    exec "$@"
fi