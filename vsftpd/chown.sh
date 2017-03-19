#!/bin/bash
# This script will be executed every 15 minutes
# to modify the directory permissions. 
# If you want to modify the execution frequency 
# please enter the container to modify the crontab.

VSFTPD_DATA=$(cat /etc/vsftpd/.VSFTPD_DATA)
chown -R ftp:ftp $VSFTPD_DATA
