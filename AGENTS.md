# Jules AI Repository Instructions: Astro Homelab

## 1. Role & Purpose
You are assisting with the Infrastructure-as-Code (IaC) setup for a home server named "Astro". 
Do not assume a standard blank Linux host. This environment runs on Unraid OS, meaning Docker networks, port allocations, and VPN routing must be handled carefully to avoid conflicts with Unraid's native services and existing containers.

## 2. Host Environment Context
- **Host IP Address:** 192.168.1.219
- **Operating System:** Unraid OS 7.2.0
- **Base Directory:** `/mnt/user/appdata/` is the absolute path on the host for all persistent configuration volumes.

## 3. Strict Port & Networking Constraints
Before writing any `docker-compose.yml` files, adhere to these existing port assignments:
- **Crafty-4 is on port 8443.** NEVER bind any new service (including reverse proxies or Unraid HTTPS fallbacks) to 8443.
- **Unraid GUI Ports:** Assume the Unraid WebGUI has been moved to port `81` (HTTP) and `9443` (HTTPS).
- **Reverse Proxy:** Nginx Proxy Manager (or Caddy) is permitted to use ports `80` and `443` on the host.
- **DNS:** Pi-hole is permitted to use port `53` (TCP/UDP). Its web interface must be mapped to `8053`.

## 4. VPN Routing Architecture (The Arr Stack)
The following containers are routed through a VPN gateway (`binhex-qbittorrentvpn`) and DO NOT have exposed host ports of their own:
- `binhex-sonarr` (Internal port: 8989)
- `binhex-radarr` (Internal port: 7878)
- `binhex-prowlarr` (Internal port: 9696 / 5010)
- `Profilarr` (Internal port: 6868)
- `Mousehole`

**Rule:** If you configure dashboards, proxies, or internal API calls targeting the Arr stack, you MUST route them to the Unraid host IP (`192.168.1.219`) using the respective internal port, because the VPN container publishes those ports to the host. Do not attempt to use `container_name:port` resolution for these specific apps.

## 5. Existing Media Stack Integration
When configuring `services.yaml` for Homepage or other API integrations, reference these existing services:
- **Plex:** Host network, port `32400`
- **Tautulli:** Bridge, port `8181`
- **Seerr:** Bridge, port `5055`
- **Audiobookshelf:** Bridge, port `13378`
- **OpenSpeedTest:** Bridge, port `4321`

## 6. Development Rules
1. **No Secrets in Repo:** Always use `.env` files for tokens, passwords, and API keys. Provide a `.env.example` in the root.
2. **Network Mode:** Use a shared external network called `homelab-net` for all new reverse proxy and DNS containers.
3. **Volume Mappings:** Always use Unraid's `/mnt/user/appdata/<service_name>` standard for local binds.
