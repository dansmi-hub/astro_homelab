# Astro Homelab (IaC)

![Unraid OS](https://img.shields.io/badge/Unraid-7.2.0-blue?style=for-the-badge&logo=unraid)
![Docker](https://img.shields.io/badge/Docker-Managed-2496ED?style=for-the-badge&logo=docker)

Infrastructure-as-Code (IaC) repository for **Astro**, an Unraid-based home server. This repository manages the Docker Compose stacks, network configurations, and dashboard setups for local DNS, reverse proxying, media management, and game servers.

## 🚀 Server Overview
* **Hostname:** Astro
* **Primary IP:** `192.168.1.219`
* **OS:** Unraid OS
* **Routing:** Arr stack and downloaders are strictly routed through a secure VPN gateway (`binhex-qbittorrentvpn`).

## 📂 Repository Structure
This repository is organized to allow modular deployment of services via Docker Compose on the Unraid host.

```text
.
├── compose/
│   ├── dns/            # Pi-hole + Unbound local DNS
│   └── proxy/          # Nginx Proxy Manager (Ports 80/443)
├── dashboard/          # Homepage (gethomepage.dev) configs
│   └── config/         # services.yaml, widgets.yaml
├── docs/               # System architecture and runbooks
├── .env.example        # Template for secrets and API keys
├── AGENTS.md           # Instructions and context for AI agents (Jules)
└── README.md
