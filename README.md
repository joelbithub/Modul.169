# Modul.169
Docker

## Learning Beispiel Shop – Microservices

This repository contains the Docker infrastructure for the Play Economy microservices learning exercise.

### Voraussetzung: Hosts-Datei Eintrag

Damit die Anwendung einwandfrei läuft, muss ein Eintrag in der Hosts-Datei gesetzt werden:

**Linux/macOS:**
```
sudo nano /etc/hosts
```

**Windows:**
```
C:\Windows\System32\drivers\etc\hosts
```

Folgenden Eintrag hinzufügen:
```
127.0.0.1 host.docker.internal
```

### Services

| Service        | URL                                    | Zugangsdaten                       |
|----------------|----------------------------------------|------------------------------------|
| Frontend       | http://host.docker.internal:5008/      | admin@play.com / Pass@word1        |
| MongoDB        | mongodb://localhost:27017              | –                                  |
| Mongo Express  | http://host.docker.internal:8080/      | admin / sml12345                   |
| RabbitMQ       | http://host.docker.internal:15672/     | guest / guest                      |
| Seq (Logging)  | http://host.docker.internal:8085/      | admin / seqadmin123                |
| Jaeger         | http://host.docker.internal:16686/     | –                                  |
| Prometheus     | http://host.docker.internal:9090/      | –                                  |
| Grafana        | http://host.docker.internal:4000/      | admin / admin                      |

### Starten

```bash
cd Play.Infra/docker
docker compose up -d
```

### Architektur

Die Anwendung besteht aus folgenden Microservices:

- **play.catalog** – Verwaltet die kaufbaren Objekte (Katalog)
- **play.inventory** – Verwaltet die gekauften Objekte des Benutzers
- **play.identity** – Überprüft die Identität (Authentifizierung)
- **play.trading** – Shop-Service: Verkauft Objekte aus dem Katalog
- **play.frontend** – Web-Frontend für den Zugriff auf die Services
- **mongo** – MongoDB Datenbank (persistent via Volume)
- **rabbitmq** – Message Broker für asynchrone Kommunikation zwischen Services
- **seq** – Zentrales Logging aller Services
- **jaeger** – Distributed Tracing
- **prometheus** – Metriken-Sammlung
- **grafana** – Dashboard-Visualisierung
