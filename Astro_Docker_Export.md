# Astro Server - Active Docker Containers Export
**Extracted and Filtered from Astro_Docker.pdf (Stopped services disregarded)**

| Application | Network | Container IP | Container Port : LAN IP Port |
| :--- | :--- | :--- | :--- |
| **audiobookshelf** | bridge | 172.17.0.3 | 80 TCP -> 192.168.1.219:13378 |
| **binhex-prowlarr** | container:binhex-qbittorrentvpn | | 5010 TCP -> 192.168.1.219:5010<br>9696 TCP -> 192.168.1.219:9696 |
| **binhex-qbittorrentvpn**| bridge | | |
| **binhex-radarr** | container:binhex-qbittorrentvpn | | |
| **binhex-sonarr** | container:binhex-qbittorrentvpn | | |
| **calibre-web-automated** | bridge | 172.17.0.5 | 8083 TCP -> 192.168.1.219:8083 |
| **Enshrouded** | bridge | 172.17.0.2 | 15637 UDP -> 192.168.1.219:15637 |
| **Foundry** | bridge | | 30000 TCP -> 192.168.1.219:30000 |
| **homepage** | bridge | | 3000 TCP -> 192.168.1.219:3000 |
| **Mousehole** | container:binhex-qbittorrentvpn | | |
| **plex** | host | 192.168.1.219 | |
| **Profilarr** | container:binhex-qbittorrentvpn | | |
| **Seerr** | bridge | 172.17.0.8 | 5055 TCP -> 192.168.1.219:5055 |
| **SpeedTestBy-OpenSpeedTest** | bridge | 172.17.0.9 | 3000 TCP -> 192.168.1.219:4321 |
| **tautulli** | bridge | 172.17.0.7 | 8181 TCP -> 192.168.1.219:8181 |
