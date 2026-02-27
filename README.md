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

## Auftrag 3 – Erklärung: Wie wurde der Webserver gemacht?

### Überblick

Der Webserver besteht aus drei Teilen, die zusammenarbeiten:

```
Dockerfile          → definiert das Docker-Image (Nginx + HTML-Dateien)
docker-compose.yml  → startet den Container mit Port-Weiterleitung und Bind-Mount
html/index.html     → die eigentliche Webseite, die Nginx ausliefert
```

---

### 1. Dockerfile – Das Image bauen

```dockerfile
FROM nginx:alpine
COPY html/ /usr/share/nginx/html/
EXPOSE 80
```

| Zeile | Bedeutung |
|---|---|
| `FROM nginx:alpine` | Verwendet das offizielle Nginx-Image auf Basis von Alpine Linux (sehr klein, ca. 25 MB). Nginx ist der Webserver, der HTTP-Anfragen entgegennimmt und HTML-Dateien ausliefert. |
| `COPY html/ /usr/share/nginx/html/` | Kopiert alle Dateien aus dem lokalen `html/`-Ordner in das Image. `/usr/share/nginx/html/` ist das Standard-Verzeichnis, aus dem Nginx Dateien ausliefert. |
| `EXPOSE 80` | Dokumentiert, dass der Container auf Port 80 lauscht (der Standard-HTTP-Port). |

**Ergebnis:** Ein fertiges Docker-Image, das Nginx inklusive der HTML-Seite enthält und sofort betrieben werden kann.

---

### 2. docker-compose.yml – Den Container konfigurieren und starten

```yaml
services:
  webserver:
    build: .
    container_name: modul169-webserver
    ports:
      - "8080:80"
    volumes:
      - ./html:/usr/share/nginx/html:ro
    restart: unless-stopped
```

| Schlüssel | Bedeutung |
|---|---|
| `build: .` | Baut das Image aus dem `Dockerfile` im aktuellen Verzeichnis. |
| `container_name` | Gibt dem Container einen festen, lesbaren Namen statt einer zufälligen ID. |
| `ports: "8080:80"` | Leitet Port **8080** auf dem Host an Port **80** im Container weiter. Darum ist die Seite unter `http://localhost:8080` erreichbar. |
| `volumes: ./html:/usr/share/nginx/html:ro` | **Bind-Mount**: Das lokale `html/`-Verzeichnis wird direkt in den Container eingehängt. `:ro` (read-only) verhindert, dass der Container-Prozess Dateien verändern kann. Änderungen auf dem Host sind sofort im Browser sichtbar. |
| `restart: unless-stopped` | Der Container startet automatisch neu, wenn er abstürzt oder der Host neu gestartet wird – bis er manuell gestoppt wird. |

---

### 3. html/index.html – Die Webseite

Die Datei `html/index.html` ist die eigentliche Webseite. Sie enthält reines HTML und CSS. Nginx liest diese Datei und sendet sie an den Browser, wenn jemand `http://localhost:8080` aufruft.

---

### Zusammenspiel der Komponenten

```
Browser  →  http://localhost:8080
              │
              │  Port-Weiterleitung (8080 → 80)
              ▼
        Docker Container
        ┌─────────────────────────┐
        │  Nginx (Port 80)        │
        │    ↕  Bind-Mount        │
        │  /usr/share/nginx/html/ │
        └──────────┬──────────────┘
                   │ zeigt auf
                   ▼
             ./html/index.html   (auf dem Host)
```

1. Der Browser sendet eine HTTP-Anfrage an `localhost:8080`.
2. Docker leitet diese Anfrage an Port 80 im Container weiter.
3. Nginx empfängt die Anfrage und sucht nach `index.html` in `/usr/share/nginx/html/`.
4. Durch den Bind-Mount zeigt dieses Verzeichnis auf den lokalen `html/`-Ordner des Hosts.
5. Nginx liest `index.html` und sendet sie als HTTP-Antwort zurück an den Browser.

---

### Funktionsweise der Persistenz

| Szenario | Ergebnis |
|---|---|
| `docker compose stop` / `docker compose start` | Webseite bleibt erhalten ✔ |
| `docker compose down` / `docker compose up -d` | Webseite bleibt erhalten ✔ |
| Host-Dateien in `html/` bearbeiten | Änderungen sofort sichtbar ✔ |

Die HTML-Dateien liegen auf dem **Host** (nicht im Container-Layer), daher gehen sie nie verloren – selbst wenn das Image neu gebaut wird.
