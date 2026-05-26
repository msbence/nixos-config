#!/usr/bin/env bash

PERCENT=$(free -t | grep Swap | awk '{printf("%0.0f%"), $3/$2*100}')
USAGE=$(free -t | grep Swap | awk '{printf("%0.1fG/%0.1fG"), $3/1024/1024, $4/1024/1024}')
echo "SWAP ${PERCENT} [${USAGE}]"
