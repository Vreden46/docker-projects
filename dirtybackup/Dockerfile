# Verwende das offizielle Ubuntu-Image
FROM ubuntu:20.04

# Installiere benötigte Pakete
RUN apt-get update && apt-get install -y \
    rsync \
    openssh-client \
    cron \
    nginx \
    && apt-get clean

# Füge den SSH-Schlüssel ins Image (ersetze dies durch den tatsächlichen Pfad)
# COPY ./path/to/your/ssh_key /root/.ssh/id_rsa

# Beispiel Pfad:
COPY ./id_rsa /root/.ssh/id_rsa

# Setze die korrekten Berechtigungen für den SSH-Schlüssel
RUN chmod 600 /root/.ssh/id_rsa

# Kopiere das Backup-Skript und den Cronjob
COPY backup.sh /usr/local/bin/backup.sh
COPY crontab.txt /etc/cron.d/backup-cron
COPY log.sh /usr/local/bin/log.sh

# Mache die Skripte ausführbar
RUN chmod +x /usr/local/bin/backup.sh /usr/local/bin/log.sh

# Einrichten der Cronjob-Konfiguration
RUN crontab /etc/cron.d/backup-cron

# Kopiere die Nginx-Konfiguration
COPY nginx.conf /etc/nginx/nginx.conf

# Exponiere Port 80 für Nginx
EXPOSE 80

# Starte den Cron-Daemon und Nginx
CMD ["sh", "-c", "cron && nginx -g 'daemon off;'"]

