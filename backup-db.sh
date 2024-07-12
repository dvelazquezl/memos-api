#!/bin/bash

DB_USER="user"
DB_PASSWORD="password"
DB_NAME="memos_dev/prod"
BACKUP_DIR="/path_to_backup_directory"
DATE=$(date +\%F)
BACKUP_FILENAME="${DB_NAME}_backup_$DATE.sql"
BACKUP_FILE="${BACKUP_DIR}/${BACKUP_FILENAME}"
NEXTCLOUD_USER="user"
NEXTCLOUD_PASSWORD="password"
UPLOAD_URL="https://tfg-nextcloud.ddns.net/remote.php/dav/files/${NEXTCLOUD_USER}/backups/${BACKUP_FILENAME}"

# Create backup
mariadb-dump -u $DB_USER -p$DB_PASSWORD $DB_NAME > $BACKUP_FILE

# remove first line of the backup to avoid compatibility issues
sed '1d' $BACKUP_FILE > $BACKUP_FILE.tmp
mv $BACKUP_FILE.tmp $BACKUP_FILE

if [ $? -eq 0 ]; then
  echo "Backup successful: $BACKUP_FILE"

  # Upload the backup file to NEXTCLOUD
  curl --location --request PUT $UPLOAD_URL \
    --user "${NEXTCLOUD_USER}:${NEXTCLOUD_PASSWORD}" \
    --upload-file $BACKUP_FILE

  if [ $? -eq 0 ]; then
    echo "Upload successful"
  else
    echo "Upload failed"
  fi
else
  echo "Backup failed"
fi
