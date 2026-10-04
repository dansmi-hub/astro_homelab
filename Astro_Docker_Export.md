# Astro Server - Docker Container Export
**Extracted from Astro_Docker.pdf**

| Application | Status | Network | Container IP | Container Port : LAN IP Port |
| :--- | :--- | :--- | :--- | :--- |
| **AMP** | Stopped | bridge | | 8080 TCP -> 192.168.1.219:8080<br>9999 -> 192.168.1.219:9999 |
| **audiobookshelf** | Started | bridge | 172.17.0.3 | 80 TCP -> 192.168.1.219:13378 |
| **binhex-code-server** | Stopped | bridge | | 8500 TCP -> 192.168.1.219:8500 |
| **binhex-krusader** | Stopped | bridge | | 6080 TCP -> 192.168.1.219:6080 |
| **binhex-official-bypasser**| Stopped | bridge | | |
| **binhex-prowlarr** | Started | container:binhex-qbittorrentvpn | | 5010 TCP -> 192.168.1.219:5010<br>9696 TCP -> 192.168.1.219:9696 |
| **binhex-qbittorrentvpn**| Started | bridge | | |
| **binhex-radarr** | Started | container:binhex-qbittorrentvpn | | |
| **binhex-sonarr** | Started | container:binhex-qbittorrentvpn | | |
| **calibre-web-automated** | Started | bridge | 172.17.0.5 | 8083 TCP -> 192.168.1.219:8083 |
| **calibre-web-automated-book-downloader** | Stopped | bridge | | |
| **Crafty-4** | Stopped | bridge | | 8123 TCP -> 192.168.1.219:8123<br>8443 TCP -> 192.168.1.219:8443 |
| **Enshrouded** | Started | bridge | 172.17.0.2 | 15637 UDP -> 192.168.1.219:15637 |
| **FileBrowser** | Stopped | bridge | 172.17.0.6 | 80 TCP -> 192.168.1.219:501 |
| **Foundry** | Started | bridge | | 30000 TCP -> 192.168.1.219:30000 |
| **glances** | Stopped | host | | |
| **homepage** | Started | bridge | | 3000 TCP -> 192.168.1.219:3000 |
| **Mousehole** | Started | container:binhex-qbittorrentvpn | | |
| **plex** | Started | host | 192.168.1.219 | |
| **Profilarr** | Started | container:binhex-qbittorrentvpn | | |
| **Seerr** | Started | bridge | 172.17.0.8 | 5055 TCP -> 192.168.1.219:5055 |
| **SpeedTestBy-OpenSpeedTest** | Started | bridge | 172.17.0.9 | 3000 TCP -> 192.168.1.219:4321 |
| **tautulli** | Started | bridge | 172.17.0.7 | 8181 TCP -> 192.168.1.219:8181 |
