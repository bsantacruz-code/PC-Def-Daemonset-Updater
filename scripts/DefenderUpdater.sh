#!/bin/bash

# Set needed variables for the script
AK=${AK}
SK=${SK}
API_URL="https://us-east1.cloud.twistlock.com/us-2-158286553"
AUTH_ENDPOINT="api/v1/authenticate"
IMAGE_NAME_ENDPOINT="api/v1/defenders/image-name"
DAEMONSET_NAME="twistlock-defender-ds"
CONTAINER_NAME="twistlock-defender"
NAMESPACE="twistlock"

# Create RBAC & ConfigMap Resources inside cluster
kubectl apply -f /app/RBAC.yaml -n $NAMESPACE
kubectl apply -f /app/ConfigMap.yaml -n $NAMESPACE

# Get token for CWP API Request, needs jq binary installed
TOKEN=$(curl --location "$API_URL/$AUTH_ENDPOINT" --header 'content-type: application/json' --data '{"username": "'"$AK"'", "password": "'"$SK"'"}' | jq -r '.token')
# Print token value
echo $TOKEN

# Get Latest Defender Docker Image Name from the CWP API 
NEW_IMAGE=$(curl -X GET --location "$API_URL/$IMAGE_NAME_ENDPOINT" --header "Authorization: Bearer $TOKEN" --header 'Content-Type: application/json' --data '')
# Delete doble quotes around Docker Image value
NEW_IMAGE="${NEW_IMAGE//\"/}"
# Print Latest Defender Docker Image Name
echo $NEW_IMAGE

# Updates ConfigMap data with new image version, it's not needed
# kubectl patch configmap defender-updater-script-configmap -n $NAMESPACE --patch='{"data":{"NEW_IMAGE":"'"$NEW_IMAGE"'"}}'

# Updates image container into Defender Daemonset with new image version and add the command to annotations
kubectl set image daemonset/$DAEMONSET_NAME $CONTAINER_NAME=$NEW_IMAGE -n $NAMESPACE --record

# Adds annotation to defender daemonset with timestamp & reason execution
kubectl annotate daemonset $DAEMONSET_NAME kubernetes.io/change-cause="Defender updated by CronJob with latest docker image at $(date -u +'%Y-%m-%dT%H:%M:%SZ')" -n $NAMESPACE