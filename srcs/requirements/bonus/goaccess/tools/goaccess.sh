#!/bin/bash

set -e

mkdir -p /var/www/html

cd /var/www/html

while true; do
    goaccess /var/log/nginx/access.log -o /var/www/html/index.html --log-format=COMBINED
    sed -i 's/<head>/<head><meta http-equiv="refresh" content="10">/' /var/www/html/index.html
    sleep 10
done &

exec python3 -m http.server 3001