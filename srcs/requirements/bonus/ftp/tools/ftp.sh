#!/bin/bash

set -e

FTP_PASS=$(cat /run/secrets/ftp_password)

if ! id "$FTP_USER" &>/dev/null; then

    useradd -m -d /var/www/html "$FTP_USER"

    echo "$FTP_USER:$FTP_PASS" | chpasswd

    usermod -aG www-data $FTP_USER

fi

exec vsftpd