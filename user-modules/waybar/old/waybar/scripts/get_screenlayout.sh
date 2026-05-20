#!/usr/bin/env bash

LAYOUT=$(cat $HOME/.current_screenlayout)
if [ -n "${LAYOUT}" ]; then
cat << EOF
{"icon": "", "state": "Idle", "text": "$LAYOUT SCREENLAYOUT"}
EOF
else
echo '{"icon": "", "state": "Idle", "text": "UNKNOWN SCREENLAYOUT"}'
fi
