#!/bin/bash

MYSQL_PASSWORD=$(cat "$MYSQL_PASSWORD_FILE")
ADMIN_PASSWORD=$(cat "$ADMIN_PASSWORD_FILE")
USER_PASSWORD=$(cat "$USER_PASSWORD_FILE")

while ! mysqladmin ping -h"mariadb" --silent; do
    sleep 1
done

cd /var/www/html

if [ ! -f wp-config.php ]; then

    wp core download --allow-root

    wp config create --dbname="$MYSQL_DATABASE" --dbuser="$MYSQL_USER" --dbpass="$MYSQL_PASSWORD" --dbhost="mariadb" --allow-root

    wp core install --url="$DOMAIN_NAME" --title="Inception" --admin_user="$ADMIN_USER" --admin_password="$ADMIN_PASSWORD" --admin_email="$ADMIN_EMAIL" --allow-root

    wp user create "$USER" "$USER_EMAIL" --role=author --user_pass="$USER_PASSWORD" --allow-root

fi

exec php-fpm8.2 -F
