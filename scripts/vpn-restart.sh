#!/usr/bin/env bash
# ==============================================================================
# Script: vpn-restart.sh
# Description: Restarts dependent Arr containers attached to the VPN container network
#              when the VPN gateway (binhex-qbittorrentvpn) restarts or re-establishes IP.
# ==============================================================================

set -euo pipefail

VPN_CONTAINER="binhex-qbittorrentvpn"
DEPENDENT_CONTAINERS=(
    "binhex-sonarr"
    "binhex-radarr"
    "binhex-prowlarr"
    "Profilarr"
    "Mousehole"
)

echo "=== Astro Homelab VPN Container Relink/Restart ==="

# Check if Docker is available
if ! command -v docker &> /dev/null; then
    echo "Error: docker command not found." >&2
    exit 1
fi

# Check if VPN container is running
if ! docker ps --format '{{.Names}}' | grep -q "^${VPN_CONTAINER}$"; then
    echo "Warning: VPN container '${VPN_CONTAINER}' is not currently running."
    echo "Attempting to start '${VPN_CONTAINER}'..."
    docker start "${VPN_CONTAINER}" || {
        echo "Error: Failed to start '${VPN_CONTAINER}'." >&2
        exit 1
    }
    sleep 5
fi

echo "Restarting containers dependent on network namespace '${VPN_CONTAINER}'..."

for container in "${DEPENDENT_CONTAINERS[@]}"; do
    if docker ps -a --format '{{.Names}}' | grep -q "^${container}$"; then
        echo "Restarting ${container}..."
        docker restart "${container}" || echo "Failed to restart ${container}"
    else
        echo "Skipping ${container} (container does not exist on host)."
    fi
done

echo "VPN restart and container relink process completed."
