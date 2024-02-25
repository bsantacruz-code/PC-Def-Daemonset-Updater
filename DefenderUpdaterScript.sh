#!/bin/bash
# Assuming you want to update the image
# Include prisma cloud API request to get last version.
NEW_IMAGE="my-app-image:new-version"
kubectl set image daemonset/my-daemonset my-app=$NEW_IMAGE --record
