#!/bin/bash

# SSH-Zugangsdaten
REMOTE_USER="root"
REMOTE_HOST="217.160.162.190"
REMOTE_PATHS=(
    "/home/root/docker/Nextcloudlife"
    "/home/root/docker/bludit"
    "/home/root/docker/proxy"
    "/home/root/docker/mailcow-dockerized"
    "/var/lib/docker/volumes"
)

# Stopp aller Docker-Container auf dem Remote-Server
echo "Stopping all Docker containers on $REMOTE_HOST..."
ssh -i /root/.ssh/id_rsa "$REMOTE_USER@$REMOTE_HOST" \
    "docker stop \$(docker ps -q)"

# Lokales Verzeichnis für Backups
LOCAL_BACKUP_DIR="/shared/webserver"

# Sicherung durchführen
for REMOTE_PATH in "${REMOTE_PATHS[@]}"; do
    rsync -avz --no-owner --no-group -e "ssh -i /root/.ssh/id_rsa" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH" "$LOCAL_BACKUP_DIR"
done

# Starten aller Docker-Container auf dem Remote-Server
echo "Starting all Docker containers on $REMOTE_HOST..."
ssh -i /root/.ssh/id_rsa "$REMOTE_USER@$REMOTE_HOST" \
    "docker start \$(docker ps -a -q)"

# Sicherungslog erstellen
echo "$(date) - Backup abgeschlossen" >> /var/log/backup.log

