#!/bin/bash

set -e

mkdir -p /var/www/html

cd /var/www/html

while true; do
    goaccess /var/log/nginx/access.log -o /var/www/html/report.html --log-format=COMBINED
    sleep 10
done &

exec python3 -m http.server 3001