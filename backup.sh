#!/usr/bin/env bash

MONTH=$(date +%b)
YEAR=$(date +%Y)
BACKUP_DIRS=( "$@" )
BACKUP_DEST=/home/backups/"$YEAR"/"$MONTH"
FILENAME=$(hostname -s).tar.gz

checkroot()
{
if [[ $EUID != 0 ]]; then
    clear 
    echo "Must be root to run this script!"
    sleep 2
    exit 1
fi
}
checkdest()
{
if [[ ! -d $BACKUP_DEST ]]; then
    mkdir -p "$BACKUP_DEST"
fi
}
checkargs()
{
if [[ $@ == 0 ]]; then
    echo "ERROR: No arguments provided to script."
    exit 1
fi
}

checkroot

checkdest

checkargs

tar -czf "$BACKUP_DEST"/"$FILENAME" "${BACKUP_DIRS[@]}" &>/dev/null

if [ -z "$(ls -A $BACKUP_DEST)" ]; then
    echo "Backup Failed!"
    sleep 3
    exit 1
else
    echo "Backup Succeeded!"
    sleep 3
    exit 0
fi
