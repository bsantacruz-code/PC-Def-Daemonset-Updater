#!/bin/bash

# Include prisma cloud API request to get last version.
NEW_IMAGE="registry-auth.twistlock.com/tw_9yc0di0pe7pc5ruq2yibvvjxrqy5znjl/twistlock/defender:defender_32_03_123"

# Execute API request to update container "twistlock" in daemonset "twistlock-defender-ds" with new image version and add the command to annotations
kubectl set image daemonset/twistlock-defender-ds twistlock-defender=$NEW_IMAGE -n twistlock --record
