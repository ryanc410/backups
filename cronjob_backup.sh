#!/bin/bash
########################################################################################
# Author: Ryan Cook https://github.com/ryanc410                                        #
#                                                                                      #
# --DESCRIPTION--                                                                      #
# Backup Script                                                                        #
# -Set up as a cronjob for automatic backups                                           #
#                                                                                      #
########################################################################################

backup_files="/etc /home /root /var/log /var/www"
dest="/home/backup"

# FILENAME
day=$(date +%A)
hostname=$(hostname -s)
archive_file="$hostname-$day.tgz"

check_old() {
    if [[ -f "$dest"/"$archive_file" ]]; then
                mv "$dest"/"$archive_file" "$dest"/2_"$archive_file"
    fi
}
check_dir() {
if [[ ! -d "$dest" ]]; then
    mkdir -p $dest
fi
}
check_dir
check_old
tar czf $dest/$archive_file $backup_files 2> /dev/null
