#!/bin/bash
########################################################################################
# Author: Ryan Cook https://github.com/ryanc410                                        #
#                                                                                      #
# --DESCRIPTION--                                                                      #                                                          
# -Provide arguments to customize what you want to backup.                             #
# -If no arguments are provided, script uses a default set of directories to backup.   #
#                                                                                      #
# SYNTAX                                                                               #
#                                                                                      #
# sudo ./backup "/dir1 /dir2 /dir3....."                                               #
#                                                                                      #
########################################################################################

###################################
# VARIABLES
##################################

# Archive Name
DAY=$(date +%m.%d.%y)
SYS_NAME=$(hostname -s)
ARCHIVE=${SYS_NAME}${DAY}.tgz

# Files/Directories
BU_FILES=( "$@" )
DEFAULT_FILES=( "/etc" "/home" "/root" )
BU_DEST=/home/backups


###################################
# FUNCTIONS
##################################

check_dir() {
    if [[ ! -d ${BU_DEST} ]]; then
        mkdir -p ${BU_DEST} &>/dev/null
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

###################################
# SCRIPT
##################################

if [[ $EUID -ne 0 ]]; then
    clear
    echo "*****    SCRIPT MUST HAVE ROOT PRIVILEGES    *****"
    sleep 2
    exit 3
fi
if [[ $@ == "" ]]; then
    echo "No directories were provided."
    echo ""
    echo "Backing up default directories."
    sleep 2
    check_dir
    tar czf ${BU_DEST}/${ARCHIVE} ${DEFAULT_FILES}
    status
else
    echo "Starting backup.."
    check_dir
    tar czf ${BU_DEST}/${ARCHIVE} ${BU_FILES}
    status
fi
