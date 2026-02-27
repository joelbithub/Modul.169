# Nginx-Image als Basis verwenden
FROM nginx:alpine

# HTML-Dateien in das Image kopieren.
# Dies ermöglicht den Betrieb ohne Docker Compose (z. B. "docker build && docker run").
# Bei Verwendung von docker-compose.yml wird dieser Layer durch den Bind-Mount überschrieben.
COPY html/ /usr/share/nginx/html/

# Port 80 freigeben
EXPOSE 80
