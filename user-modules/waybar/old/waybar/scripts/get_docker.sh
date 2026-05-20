#!/usr/bin/env bash

ALL=$(docker system info --format='{{json .Containers}}')
RUNNING=$(docker system info --format='{{json .ContainersRunning}}')
echo "DOCKER ${RUNNING}/${ALL}"
