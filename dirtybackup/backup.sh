

#!/bin/bash

# SSH-Zugangsdaten
REMOTE_USER="root"
REMOTE_HOST="xxx.xxx.xxx.xxx"
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

# Erstellen von tar.gz-Archiven auf dem Remote-Server
#echo "Compressing directories on $REMOTE_HOST..."
#for REMOTE_PATH in "${REMOTE_PATHS[@]}"; do
    #REMOTE_BASENAME=$(basename "$REMOTE_PATH")
    #ssh -i /root/.ssh/id_rsa "$REMOTE_USER@$REMOTE_HOST" \
        #"tar -czf /tmp/${REMOTE_BASENAME}.tar.gz -C $(dirname "$REMOTE_PATH") $REMOTE_BASENAME"
#done

## Übertragung der komprimierten Dateien
#echo "Transferring compressed files..."
#for REMOTE_PATH in "${REMOTE_PATHS[@]}"; do
    #REMOTE_BASENAME=$(basename "$REMOTE_PATH")
    #rsync -avz --no-owner --no-group -e "ssh -i /root/.ssh/id_rsa" "$REMOTE_USER@$REMOTE_HOST:/tmp/${REMOTE_BASENAME}.tar.gz" "$LOCAL_BACKUP_DIR"
#done


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

