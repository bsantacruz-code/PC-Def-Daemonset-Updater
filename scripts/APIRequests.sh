#!/bin/bash

# Set needed variables for the script
AK="Your Access Key"
SK="#Your Secret Key"
API_URL="https://us-east1.cloud.twistlock.com/us-2-158286553"
AUTH_ENDPOINT="api/v1/authenticate"
IMAGE_NAME_ENDPOINT="api/v1/defenders/image-name"

# Get token for CWP API Request, needs jq binary installed
TOKEN=$(curl --location "$API_URL/$AUTH_ENDPOINT" --header 'content-type: application/json' --data '{"username": "'"$AK"'", "password": "'"$SK"'"}' | jq -r '.token')
# Print token value
echo $TOKEN

# Get Latest Defender Docker Image Name from the CWP API 
NEW_IMAGE=$(curl -X GET --location "$API_URL/$IMAGE_NAME_ENDPOINT" --header "Authorization: Bearer $TOKEN" --header 'Content-Type: application/json' --data '')
# Delete doble quotes around value
NEW_IMAGE="${NEW_IMAGE//\"/}"
# Print Latest Defender Docker Image Name
echo $NEW_IMAGE