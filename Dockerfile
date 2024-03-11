# Use Alpine as the base image
FROM alpine:latest

# Include bash binary
RUN apk add --no-cache bash

# Set the kubectl version to download
ENV KUBECTL_VERSION=v1.28.4

# Install necessary packages (curl & jq)
RUN apk add --no-cache curl ca-certificates jq

# Download kubectl, make it executable, and move it to /usr/local/bin
RUN curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin/kubectl

# Verify kubectl & jq are installed
RUN kubectl version --client --output=yaml
RUN jq --version

# Set the working directory
WORKDIR /app

# Copy the app files to Docker Image
COPY ./yaml/* /app/
COPY ./scripts/* /app/

# Default command or entrypoint
CMD ["/bin/sh"]