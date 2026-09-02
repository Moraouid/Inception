#!/bin/bash

MYSQL_PASSWORD=$(cat "$MYSQL_PASSWORD_FILE")
MYSQL_ROOT_PASSWORD=$(cat "$MYSQL_ROOT_PASSWORD_FILE")

service mariadb start && sleep 2

mysql -u root -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};"

mysql -u root -e "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';"

mysql -u root -e "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%' IDENTIFIED BY '$(cat "$MYSQL_PASSWORD_FILE")';"

mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';"

mysql -u root -e "FLUSH PRIVILEGES;"

mysqladmin -u root -p"$MYSQL_ROOT_PASSWORD" shutdown

exec mysqld --user=mysql