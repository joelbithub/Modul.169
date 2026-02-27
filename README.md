# Modul 169 – Docker Webserver

## Auftrag 1 – Nginx-Webserver in einem Docker-Container

Dieses Repository enthält einen **Nginx**-Webserver, der in einem Docker-Container läuft und eine einfache HTML-Seite ausliefert. Die Webseite bleibt auch nach dem Stoppen und Starten des Containers verfügbar, weil der Inhalt über ein **Bind-Mount-Volume** eingebunden wird (das lokale `html/`-Verzeichnis wird direkt in den Container gemountet).

### Projektstruktur

```
.
├── Dockerfile           # Nginx-Image-Definition
├── docker-compose.yml   # Container-Konfiguration mit Volume
└── html/
    └── index.html       # Die veröffentlichte Webseite
```

---

## Auftrag 2 – Anleitung

### Voraussetzungen

- [Docker](https://docs.docker.com/get-docker/) installiert
- [Docker Compose](https://docs.docker.com/compose/install/) installiert (ab Docker Desktop bereits enthalten)

### Webserver starten

```bash
# Repository klonen
git clone https://github.com/joelbithub/Modul.169.git
cd Modul.169

# Container bauen und starten (im Hintergrund)
docker compose up -d --build
```

Die Webseite ist danach unter **http://localhost:8080** erreichbar.

### Webserver stoppen und wieder starten

```bash
# Container stoppen
docker compose stop

# Container wieder starten (Webseite ist sofort wieder verfügbar)
docker compose start
```

Da das `html/`-Verzeichnis als Bind-Mount eingehängt ist (`./html:/usr/share/nginx/html:ro`), bleiben alle HTML-Dateien auf dem Host erhalten – unabhängig vom Zustand des Containers.

### Webseite aktualisieren (zukünftige Änderungen veröffentlichen)

1. Die Datei `html/index.html` (oder weitere Dateien im Ordner `html/`) bearbeiten.
2. Da das Verzeichnis direkt in den Container gemountet ist, ist die Änderung **sofort sichtbar** – ein Neustart des Containers ist **nicht** nötig.

```bash
# Beispiel: Seite bearbeiten
nano html/index.html

# Fertig – beim nächsten Browser-Reload ist die Änderung sichtbar
```

### Container komplett entfernen

```bash
docker compose down
```

---

### Funktionsweise der Persistenz

| Szenario | Ergebnis |
|---|---|
| `docker compose stop` / `docker compose start` | Webseite bleibt erhalten ✔ |
| `docker compose down` / `docker compose up -d` | Webseite bleibt erhalten ✔ |
| Host-Dateien in `html/` bearbeiten | Änderungen sofort sichtbar ✔ |

Die HTML-Dateien liegen auf dem **Host** (nicht im Container-Layer), daher gehen sie nie verloren – selbst wenn das Image neu gebaut wird.
