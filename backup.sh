#!/bin/bash
########################################################################################
# Author: Ryan Cook https://github.com/ryanc410                                        #
#                                                                                      #
# --DESCRIPTION--                                                                      #
# Interactive Backup Script                                                            #
# -Provide arguments to customize what you want to backup.                             #
# -If no arguments are provided, script uses a default set of directories to backup.   #
#                                                                                      #
# SYNTAX                                                                               #
#                                                                                      #
# sudo ./backup "/dir1 /dir2 /dir3....."                                               #
#                                                                                      #
########################################################################################

backup_files=( "$@" )
default_backup_files="/etc /home /root /var/log /var/www"
dest="/backups"

# FILENAME
day=$(date +%A)
hostname=$(hostname -s)
archive_file="$hostname-$day.tgz"

check_old() {
    if [[ -f "$dest"/"$archive_file" ]]; then
        echo "A Backup already exists.. Do you wish to delete the old backup file?"
        read opt1
        case $opt1 in
            y|Y|yes|Yes)
                rm -rf "$dest"/"$archive_file"
                ;;
            n|N|no|No)
                mv "$dest"/"$archive_file" "$dest"/2_"$archive_file"
                ;;
            *)
                echo "$opt1 was not a valid choice. Exiting..."
                sleep 2
                exit 5
                ;;
        esac
    fi
}
check_dir() {
if [[ ! -d "$dest" ]]; then
    echo ""$dest" does not exist... Creating it now.."
    mkdir -p $dest
fi
}
status() {
    if [[ $? -eq 0 ]]; then
        echo "Backup Completed Successfully!"
        sleep 2
        exit 0
    else
        echo "There was a problem completing the backup..."
        sleep 2
        exit 4
    fi
}
if [[ $EUID -ne 0 ]]; then
    echo "Run it as root."
    sleep 2
    exit 3
fi

if [[ $@ == "" ]]; then
    echo "No directories were passed to the script."
    echo ""
    echo "Backing up "$default_backup_files" as default."
    sleep 2
    check_dir
    check_old
    tar czf $dest/$archive_file $default_backup_files 2> /dev/null
    status
else
    echo "Starting backup of "$backup_files"..."
    check_dir
    check_old
    tar czf $dest/$archive_file $backup_files 2> /dev/null
    status
fi
