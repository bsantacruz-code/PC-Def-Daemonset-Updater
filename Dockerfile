# Use Alpine as the base image
FROM alpine:latest

# Include bash binary
RUN apk add --no-cache bash

# Set the kubectl version to download
ENV KUBECTL_VERSION=v1.28.4

# Install necessary packages
RUN apk add --no-cache curl ca-certificates

# Download kubectl, make it executable, and move it to /usr/local/bin
RUN curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin/kubectl

# Verify kubectl is installed
RUN kubectl version --client --output=yaml

# Your container's CMD or ENTRYPOINT goes here
# For example, set an ENTRYPOINT to use kubectl by default
ENTRYPOINT ["/usr/local/bin/kubectl"]