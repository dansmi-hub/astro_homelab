#!/usr/bin/env bash
# ==============================================================================
# Script: init-networks.sh
# Description: Ensures external Docker network 'homelab-net' exists.
# ==============================================================================

set -euo pipefail

NETWORK_NAME="homelab-net"

if docker network inspect "${NETWORK_NAME}" >/dev/null 2>&1; then
    echo "Network '${NETWORK_NAME}' already exists."
else
    echo "Creating external Docker network '${NETWORK_NAME}'..."
    docker network create "${NETWORK_NAME}"
    echo "Network '${NETWORK_NAME}' created successfully."
fi
