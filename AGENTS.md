# Jules AI Repository Instructions: Astro Homelab

## 1. Role & Purpose
You are assisting with the Infrastructure-as-Code (IaC) setup for a home server named "Astro". 
Do not assume a standard Linux host. This environment runs on Unraid OS, meaning Docker networks, port allocations, and VPN container routing must be handled according to Unraid conventions.

## 2. Host Environment Context
- **Host IP Address:** 192.168.1.219
- **Operating System:** Unraid OS 7.2.0
- **Base Appdata Directory:** `/mnt/user/appdata/` is the absolute path on the host for all persistent configuration volumes.

## 3. Host Port & Networking Constraints
- **Unraid GUI Ports:** Assume the Unraid WebGUI is shifted to port `81` (HTTP) and `9443` (HTTPS) to free up standard web ports.
- **Reverse Proxy (Nginx Proxy Manager / Caddy):** Uses host ports `80` and `443`.
- **DNS (Pi-hole + Unbound):** Pi-hole listens on host port `53` (TCP/UDP). Web admin interface is mapped to port `8053`.

## 4. Arr Stack Architecture (Container Network VPN)
The Arr stack applications do not run on isolated Docker bridge networks. Instead, they run in `container:binhex-qbittorrentvpn` network mode, attaching directly to the VPN container's network stack for leak prevention.

### Default Ports:
- **Sonarr:** `8989`
- **Radarr:** `7878`
- **Prowlarr:** `9696` (or alternate `5010` if remapped)
- **qBittorrent Web UI:** `8080`
- **Profilarr:** `6868`

### CRITICAL Networking & DNS Rules:
1. **No Direct Container-Name DNS:** Because these containers share the `binhex-qbittorrentvpn` network namespace, Docker DNS cannot resolve `http://binhex-sonarr:8989` or `http://binhex-radarr:7878` from external custom networks (such as `homelab-net`).
2. **Reverse Proxy (NPM) & Dashboard (Homepage) Target:**
   - Any external reverse proxy or dashboard service reaching the Arr stack must target the Unraid host IP:
     - `http://192.168.1.219:8989` (Sonarr)
     - `http://192.168.1.219:7878` (Radarr)
     - `http://192.168.1.219:9696` (Prowlarr)
     - `http://192.168.1.219:8080` (qBittorrent)
3. **Internal Inter-App Communication (Arr to qBittorrent / Prowlarr to Sonarr):**
   - Apps sharing the VPN container network communicate with each other over `localhost` (e.g., `http://localhost:8080` for torrent downloads, `http://localhost:8989` for Sonarr).

## 5. Existing Media Stack Integration
Reference these active standalone services running on the server:
- **Plex:** Host network, port `32400`
- **Tautulli:** Bridge network, port `8181`
- **Seerr:** Bridge network, port `5055`
- **Audiobookshelf:** Bridge network, port `13378`
- **Calibre-Web:** Bridge network, port `8083`
- **OpenSpeedTest:** Bridge network, port `4321`

## 6. Development Rules
1. **Zero Secrets in Git:** Always use `.env` files for tokens, passwords, and API keys. Provide a fully annotated `.env.example` in the root.
2. **Shared Docker Network:** Create an external bridge network called `homelab-net` for all newly composed reverse proxy and DNS containers.
3. **Volume Mappings:** Always use Unraid's `/mnt/user/appdata/<service_name>` standard for local binds.
