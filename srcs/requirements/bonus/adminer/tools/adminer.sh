#!/bin/bash

mkdir -p /var/www/html

chown -R www-data:www-data /var/www/html

exec php-fpm8.2 -F