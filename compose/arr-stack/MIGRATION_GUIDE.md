# Unraid Docker Compose Migration Runbook: Arr Stack & Accessories

This runbook provides step-by-step instructions for migrating an existing Unraid XML-template-based media and automation stack to **Unraid's Docker Compose Manager** on server **Astro** (`192.168.1.219`).

---

## 1. Overview & Network Architecture

### Host Environment Context
* **Host IP:** `192.168.1.219`
* **Operating System:** Unraid OS 7.2.0
* **Appdata Root Directory:** `/mnt/user/appdata/<service_name>`
* **Data Root Directory:** `/mnt/user/data/` (contains `/mnt/user/data/torrents`, `/mnt/user/data/media`, etc.)

### VPN Container Networking Rules
1. **VPN Network Mode (`network_mode: "service:vpn"`):** All indexer-facing and torrent-downloading containers (`binhex-qbittorrentvpn`, `binhex-sonarr`, `binhex-radarr`, `binhex-prowlarr`, `bazarr`, `readarr`, `flaresolverr`, `profilarr`, `mousehole`) share the network stack of the `vpn` gateway (`binhex-qbittorrentvpn`).
2. **Port Exposure:** All host ports (`8080`, `8989`, `7878`, `9696`, `6767`, `8787`, `8191`, `6868`, `5010`, `6881`) are defined directly on the `vpn` gateway container block.
3. **Inter-Container Communication (VPN Stack):** Applications sharing `network_mode: "service:vpn"` communicate with each other over `localhost` (e.g. Sonarr reaching qBittorrent at `http://localhost:8080`, Prowlarr reaching Sonarr at `http://localhost:8989`).
4. **External Services Communication:** Services running outside the VPN stack (e.g. `unpackerr`, `homepage`, `nginx-proxy-manager`, or external browsers) reach these containers via `http://192.168.1.219:<port>`.
5. **LAN Network Subnet (`LAN_NETWORK`):** Setting `LAN_NETWORK=192.168.1.0/24` in `.env` is **mandatory**. The `binhex-qbittorrentvpn` container uses strict `iptables` rules (killswitch). If `LAN_NETWORK` is missing or mismatched, iptables drops local subnet traffic, locking you out of the container Web UIs.

---

## 2. Pre-Migration Checklist

- [ ] **Backup Existing Appdata:**
  Take a backup of `/mnt/user/appdata/` directories for all affected containers using Appdata Backup plugin or tar archive:
  ```bash
  tar -czvf /mnt/user/system/appdata_arr_backup.tar.gz \
    /mnt/user/appdata/binhex-qbittorrentvpn \
    /mnt/user/appdata/binhex-sonarr \
    /mnt/user/appdata/binhex-radarr \
    /mnt/user/appdata/binhex-prowlarr \
    /mnt/user/appdata/bazarr \
    /mnt/user/appdata/readarr \
    /mnt/user/appdata/flaresolverr \
    /mnt/user/appdata/profilarr \
    /mnt/user/appdata/mousehole \
    /mnt/user/appdata/unpackerr
  ```
- [ ] **Verify Shared Network:**
  Ensure the external Docker network `homelab-net` exists:
  ```bash
  docker network create homelab-net || true
  ```
- [ ] **Copy Environment File:**
  Copy `.env.example` to `.env` in `compose/arr-stack/`:
  ```bash
  cp compose/arr-stack/.env.example compose/arr-stack/.env
  ```
  Edit `.env` and fill in your VPN credentials (`VPN_USER`, `VPN_PASS`), LAN network (`LAN_NETWORK=192.168.1.0/24`), and API keys.

---

## 3. Step-by-Step Migration Guide

### Step 1: Stop Existing Unraid XML Containers
1. Log into the Unraid WebGUI (`http://192.168.1.219:81`).
2. Navigate to the **Docker** tab.
3. Stop the following XML-managed containers gracefully:
   - `binhex-qbittorrentvpn`
   - `binhex-sonarr`
   - `binhex-radarr`
   - `binhex-prowlarr`
   - `bazarr`
   - `binhex-readarr` (or `readarr`)
   - `flaresolverr`
   - `Profilarr`
   - `Mousehole`
   - `unpackerr`

### Step 2: Disable Autostart for XML Containers
1. On the Unraid Docker tab, toggle the **Autostart** switch to **OFF** for each of the stopped containers listed above.
2. *Note:* **Do not delete application data.** Leaving the appdata folders under `/mnt/user/appdata/` intact preserves all existing databases, settings, torrent histories, and API keys.

### Step 3: Deploy Stack via Docker Compose Manager
1. In the Unraid WebGUI, open **Docker Compose Manager** (or Compose plugin in Unraid 7.x).
2. Create a new project named `arr-stack`.
3. Set the project folder location to `/boot/config/plugins/docker.compose/projects/arr-stack` or repository path `/mnt/user/appdata/compose/arr-stack`.
4. Place the generated `docker-compose.yml` and `.env` files into the project directory.
5. Click **Compose Up** (or execute `docker compose up -d` in terminal inside `compose/arr-stack/`).

---

## 4. Port & Service Reference Table

| Service | Container Name | Port | External Host URL | Inter-App (VPN Stack) URL | Network Mode | Volume Mount Path |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **VPN / qBittorrent** | `binhex-qbittorrentvpn` | 8080 | `http://192.168.1.219:8080` | `http://localhost:8080` | bridge (homelab-net) | `/mnt/user/appdata/binhex-qbittorrentvpn:/config` |
| **Sonarr** | `binhex-sonarr` | 8989 | `http://192.168.1.219:8989` | `http://localhost:8989` | `service:vpn` | `/mnt/user/appdata/binhex-sonarr:/config` |
| **Radarr** | `binhex-radarr` | 7878 | `http://192.168.1.219:7878` | `http://localhost:7878` | `service:vpn` | `/mnt/user/appdata/binhex-radarr:/config` |
| **Prowlarr** | `binhex-prowlarr` | 9696 | `http://192.168.1.219:9696` | `http://localhost:9696` | `service:vpn` | `/mnt/user/appdata/binhex-prowlarr:/config` |
| **Bazarr** | `bazarr` | 6767 | `http://192.168.1.219:6767` | `http://localhost:6767` | `service:vpn` | `/mnt/user/appdata/bazarr:/config` |
| **Readarr** | `binhex-readarr` | 8787 | `http://192.168.1.219:8787` | `http://localhost:8787` | `service:vpn` | `/mnt/user/appdata/readarr:/config` |
| **FlareSolverr** | `flaresolverr` | 8191 | `http://192.168.1.219:8191` | `http://localhost:8191` | `service:vpn` | N/A |
| **Profilarr** | `profilarr` | 6868 | `http://192.168.1.219:6868` | `http://localhost:6868` | `service:vpn` | `/mnt/user/appdata/profilarr:/config` |
| **Mousehole** | `mousehole` | 5010 | `http://192.168.1.219:5010` | `http://localhost:5010` | `service:vpn` | `/mnt/user/appdata/mousehole:/var/lib/mousehole` |
| **Unpackerr** | `unpackerr` | N/A | N/A | N/A | homelab-net | `/mnt/user/appdata/unpackerr:/config` |

---

## 5. Post-Deployment Verification

1. **Verify VPN Connection & IP Leak Protection:**
   Check logs for `binhex-qbittorrentvpn`:
   ```bash
   docker logs binhex-qbittorrentvpn
   ```
   Confirm message: `[info] VPN connection established successfully` and that assigned external IP is from your VPN provider.

2. **Verify Database & Session Persistence:**
   Access Web UIs from a browser on the local LAN:
   - qBittorrent: `http://192.168.1.219:8080`
   - Sonarr: `http://192.168.1.219:8989`
   - Radarr: `http://192.168.1.219:7878`
   - Prowlarr: `http://192.168.1.219:9696`
   Confirm that all existing series, movies, indexers, and settings are intact.

3. **Verify Inter-App Settings:**
   In Sonarr and Radarr settings (Download Clients tab):
   - Host should be set to `localhost` and Port `8080`.
   In Prowlarr settings (Applications tab):
   - Sonarr URL: `http://localhost:8989`
   - Radarr URL: `http://localhost:7878`

4. **Verify Unpackerr:**
   Check logs for `unpackerr`:
   ```bash
   docker logs unpackerr
   ```
   Ensure Unpackerr connects successfully to Sonarr and Radarr via `http://192.168.1.219:8989` and `http://192.168.1.219:7878`.

---

## 6. Troubleshooting & Rollback Instructions

### Web UI Unreachable (Connection Timed Out)
* **Root Cause:** Incorrect `LAN_NETWORK` in `.env` resulting in iptables killswitch blocking WebUI traffic.
* **Fix:** Verify host IP subnet (e.g. `192.168.1.0/24`) and update `.env`. Restart the stack (`docker compose down && docker compose up -d`).

### Inter-App Connection Refused
* **Root Cause:** Attempting to use container names (e.g. `http://binhex-sonarr:8989`) between VPN-routed containers.
* **Fix:** Update host settings in Sonarr/Radarr/Prowlarr to use `localhost:<port>`.

### Emergency Rollback Procedure
If any issue prevents proper stack operation:
1. Stop the Compose stack:
   ```bash
   docker compose -f compose/arr-stack/docker-compose.yml down
   ```
2. Open the Unraid Docker tab (`http://192.168.1.219:81`).
3. Re-enable **Autostart** and start your original XML containers.
4. All application state in `/mnt/user/appdata/` will remain unmodified.
