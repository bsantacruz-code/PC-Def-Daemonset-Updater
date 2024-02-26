#!/bin/bash

DAEMONSET_NAME="twistlock-defender-ds"
CONTAINER_NAME="twistlock-defender"

# Include prisma cloud API request to get last version:
NEW_IMAGE="registry-auth.twistlock.com/tw_9yc0di0pe7pc5ruq2yibvvjxrqy5znjl/twistlock/defender:defender_32_03_123"

# Updates image container into Defender Daemonset with new image version and add the command to annotations:
kubectl set image daemonset/$DAEMONSET_NAME $CONTAINER_NAME=$NEW_IMAGE -n twistlock --record

# Adds anottation to defender daemonset with timestamp & reason execution: 
kubectl annotate daemonset $DAEMONSET_NAME kubernetes.io/change-cause="Defender updated by CronJob with latest docker image at $(date -u +'%Y-%m-%dT%H:%M:%SZ')" -n twistlock
